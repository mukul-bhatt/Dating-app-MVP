//
//  ChatViewModel.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 04/02/26.
//

import Foundation
import Combine
import PhotosUI
import SwiftUI




class ChatViewModel: ObservableObject
{
    @Published var lastMessageId: String? // Changed to String to support both UUID and Int IDs
    @Published var groupedMessages: [DateGroup] = []
    @Published var messageFieldValue: String = ""
    @Published var isBlockedByMe: Bool = false
    @Published var isBlockedByThem: Bool = false
    @Published var isReceiverTyping: Bool = false

    
    // Photo Selection
    @Published var selectedPhotoItem: PhotosPickerItem? {
        didSet {
            if let item = selectedPhotoItem {
                handlePhotoSelection(item)
            }
        }
    }
    @Published var selectedImage: UIImage?
    
    // Track current session details
    private var userId: Int?
    private var conversationId: Int?
    private var receiverId: Int?
    @Published var receiverName: String = "Nia Sharma" // default placeholder
    @Published var receiverImageURL: URL?
    
    private var cancellables = Set<AnyCancellable>()

    init() {
        self.groupedMessages = []
    }

    func sendGreeting() {
        self.messageFieldValue = "Hi! 👋"
        sendMessage()
    }

    func connect(userId: Int, conversationId: Int, receiverId: Int, name: String? = nil, imageURL: URL? = nil, initialMessage: String? = nil, notificationsManager: NotificationsManager? = nil) {
        var resolvedConvId = conversationId
        var resolvedImageUrl = imageURL
        
        // 🚀 Resolution Logic: If ID is 0, try to find it in the cached inbox
        if resolvedConvId == 0, let manager = notificationsManager {
            if let existing = manager.inboxItems.first(where: { $0.profileId == receiverId }) {
                print("🔍 Resolved conversation ID \(existing.conversationId) from inbox cache for user \(receiverId)")
                resolvedConvId = existing.conversationId
                
                // Also pick up the image if missing
                if resolvedImageUrl == nil {
                    resolvedImageUrl = existing.profile
                }
            }
        }

        print("🔌 ViewModel connecting: user=\(userId), conv=\(resolvedConvId), receiver=\(receiverId), name=\(name ?? "nil")")
        self.userId = userId
        self.conversationId = resolvedConvId
        self.receiverId = receiverId
        self.receiverName = (name == nil || name!.isEmpty) ? "Chat" : name!
        self.receiverImageURL = resolvedImageUrl
        
        // 1. If we have an initial message (from deep link), show it immediately
        if let firstMsg = initialMessage, !firstMsg.isEmpty {
            let chatMsg = ChatMessage(
                id: Int.random(in: 100000...999999),
                type: "text",
                toUserId: receiverId,
                conversationId: resolvedConvId,
                isRead: false,
                readAt: "",
                status: "sent",
                content: firstMsg,
                createdAt: ISO8601DateFormatter().string(from: Date())
            )
            self.appendToGroups(chatMsg)
        }

        // 2. Fetch History (only if conversation actually exists)
        if self.conversationId! > 0 {
            fetchMessageHistory(conversationId: self.conversationId!)
        } else {
            print("🆕 New conversation detected (ID 0). Skipping history fetch.")
        }
        
        // 3. Setup Callbacks via Combine
        cancellables.removeAll()
        
        ChatSocketManager.shared.chatMessageSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                self?.handleSentAcknowledgment(message)
            }
            .store(in: &cancellables)
        
        ChatSocketManager.shared.receivedMessageSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                self?.handleIncomingReceivedMessage(message)
            }
            .store(in: &cancellables)

        ChatSocketManager.shared.notificationSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] notification in
                self?.handleIncomingNotification(notification)
            }
            .store(in: &cancellables)
        
        ChatSocketManager.shared.typingEventSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] payload in
                self?.handleTypingEvent(payload)
            }
            .store(in: &cancellables)
        
        // Request fresh counts as entering a chat often changes unread status
        notificationsManager?.requestUnreadCounts()
    }


    
    func sendMessage() {
        let text = messageFieldValue
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        guard let userId = userId, let conversationId = conversationId, let receiverId = receiverId else {
            print("❌ Cannot send message: Missing session info")
            return
        }

        let tempId = Int.random(in: 100000...999999)
        let chatMsg = ChatMessage(
            id: tempId,
            type: "text",
            toUserId: userId, // Set to me (sender)
            conversationId: conversationId,
            isRead: false,
            readAt: "",
            status: "sending",
            content: text,
            createdAt: ISO8601DateFormatter().string(from: Date())
        )
        
        // 1. Add to local UI
        appendToGroups(chatMsg)
        messageFieldValue = ""
        
        // 2. Send via REST (as per user instruction)
        let restRequest = SendMessageRequest(
            ConversationId: "\(conversationId)",
            MessageType: "Text",
            Content: text,
            ReceiverId: "\(receiverId)"
        )
        
        Task {
            do {
                let response: SendMessageResponse = try await NetworkManager.shared.request(endpoint: .sendMessage, body: restRequest)
                if !response.success {
                    if response.message == "You cant send message to this user" {
                        await MainActor.run {
                            self.isBlockedByThem = true
                        }
                    }
                }
            } catch {
                print("❌ Failed to send message via REST: \(error)")
            }
        }
    }
    
    // MARK: - Socket Handlers
    
    func fetchMessageHistory(conversationId: Int) {
        Task {
            do {
                let response: ConversationResponse = try await NetworkManager.shared.request(endpoint: .fetchConversationsByGroup(conversationId: conversationId))
                
                if response.success {
                    await MainActor.run {
                        print("📜 Loaded \(response.data.count) date groups")
                        self.groupedMessages = response.data
                        self.isBlockedByMe = response.isBlocked
                        
                        // Scroll to bottom if there are messages
                        if let lastGroup = response.data.last, let lastMsg = lastGroup.messages.last {
                            self.lastMessageId = "\(lastMsg.id)"
                        }
                    }
                }
            } catch {
                print("❌ Failed to fetch history: \(error)")
            }
        }
    }
    
    func handleIncomingReceivedMessage(_ receivedMessage: SocketReceivedMessage) {
        // Accept message if it belongs to this conversation OR if it's from the person we are chatting with
        guard receivedMessage.conversationId == self.conversationId || receivedMessage.fromUserId == self.receiverId else {
            return
        }
        
        // Ignore if from self (though usually incoming messages are from others)
        guard receivedMessage.fromUserId != self.userId else { return }
        
        // 🚀 Update to use the server's conversation ID if it changed/was placeholder
        if self.conversationId != receivedMessage.conversationId {
            print("🔄 Updating conversationId to \(receivedMessage.conversationId)")
            self.conversationId = receivedMessage.conversationId
        }
        
        let chatMsg = ChatMessage(
            id: Int.random(in: 100000...999999),
            type: receivedMessage.type,
            toUserId: receivedMessage.fromUserId, // Set to the sender
            conversationId: receivedMessage.conversationId,
            isRead: false,
            readAt: "",
            status: "delivered",
            content: receivedMessage.content,
            createdAt: ISO8601DateFormatter().string(from: receivedMessage.created_At)
        )
        
        // Append to UI list
        DispatchQueue.main.async {
            self.appendToGroups(chatMsg)
        }
    }
    
    func handleSentAcknowledgment(_ socketMessage: SentAckEvent) {
        // This is an echo/ack of our own message
        print("✅ Message successfully processed by server")
        // We could update a 'delivered' status here if we had one
    }
    
    func handleIncomingNotification(_ notification: NotificationEvent) {
        let type = notification.data.notificationType ?? notification.data.type
        if type == "message" {
            let incomingConvId = notification.data.ConversationId
            let senderId = notification.data.FromUserId
            
            // Match logic: Same conversation ID OR same sender (if no ID yet)
            let isCurrentConv = (incomingConvId != nil && incomingConvId == self.conversationId)
            let isFromCurrentReceiver = (senderId == self.receiverId)
            
            if isCurrentConv || isFromCurrentReceiver {
                let chatMsg = ChatMessage(
                    id: Int.random(in: 100000...999999),
                    type: "text",
                    toUserId: senderId, // Set to the sender
                    conversationId: incomingConvId ?? self.conversationId ?? 0,
                    isRead: false,
                    readAt: "",
                    status: "delivered",
                    content: notification.data.Message,
                    createdAt: ISO8601DateFormatter().string(from: Date())
                )
                DispatchQueue.main.async {
                    self.appendToGroups(chatMsg)
                }
            }
        }
    }
    
    func handleTypingEvent(_ payload: SocketTypingPayload) {
        // Ensure the typing event is for this conversation and from the current receiver
        // Note: ReceiverId in the outgoing payload from the other party is 'us', 
        // so we check if the sender of that typing event is our current receiverId.
        guard payload.ConversationId == self.conversationId || payload.ReceiverId == self.receiverId else {
            return
        }
        
        // Update typing status
        withAnimation {
            self.isReceiverTyping = payload.IsTyping
        }
        
        // Auto-stop if we don't get a stop event (safety)
        if payload.IsTyping {
            // Cancel any previous safety timer
            // For simplicity, we just use a dispatch after. 
            // If they are actually typing, it will keep resetting isReceiverTyping to true anyway.
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
                if self?.isReceiverTyping == true {
                    withAnimation {
                        self?.isReceiverTyping = false
                    }
                }
            }
        }
    }


    private func appendToGroups(_ message: ChatMessage) {
        // WhatsApp style: check if "Today" exists
        let todayLabel = "Today"
        
        if let index = groupedMessages.firstIndex(where: { $0.dateGroup.lowercased() == todayLabel.lowercased() }) {
            var updatedGroup = groupedMessages[index]
            var messages = updatedGroup.messages
            messages.append(message)
            updatedGroup = DateGroup(dateGroup: updatedGroup.dateGroup, messageDate: updatedGroup.messageDate, messages: messages)
            groupedMessages[index] = updatedGroup
        } else {
            // Create Today group
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM yyyy"
            let todayDateStr = formatter.string(from: Date())
            let newGroup = DateGroup(dateGroup: todayLabel, messageDate: todayDateStr, messages: [message])
            groupedMessages.append(newGroup)
        }
        
        self.lastMessageId = "\(message.id)"
    }

    func blockUser(status: String = "Blocked") async -> Bool {
        guard let receiverId = receiverId else {
            print("❌ Cannot block user: Missing receiverId")
            return false
        }
        
        let requestBody = BlockUserRequest(toUserId: "\(receiverId)", status: status)
        
        do {
            let response: BlockUserResponse = try await NetworkManager.shared.request(endpoint: .blockProfile, body: requestBody)
            print("🚫 Block User API Response: \(response)")
            
            if response.success {
                await MainActor.run {
                    self.isBlockedByMe = true
                }
            }
            
            return response.success
        } catch {
            print("❌ Failed to block user: \(error)")
            return false
        }
    }

    func unblockUser() async -> Bool {
        guard let receiverId = receiverId else { return false }
        
        let requestBody = UnblockRequest(toUserId: "\(receiverId)", status: "Unblock")
        
        do {
            let response: GenericResponse = try await NetworkManager.shared.request(
                endpoint: .unblockUser,
                body: requestBody
            )
            
            if response.success {
                await MainActor.run {
                    self.isBlockedByMe = false
                }
                return true
            }
            return false
        } catch {
            print("❌ Failed to unblock user: \(error)")
            return false
        }
    }

    func deleteChat() async -> Bool {
        guard let conversationId = self.conversationId else { return false }
        
        let body = DeleteMessageRequest(MessageIds: [], ConversationId: "\(conversationId)")
        
        do {
            let response: BasicResponse = try await NetworkManager.shared.request(endpoint: .deleteMessage, body: body)
            if response.success {
                await MainActor.run {
                    self.groupedMessages = []
                }
                return true
            }
            return false
        } catch {
            print("❌ Failed to delete chat: \(error)")
            return false
        }
    }

    func parseHistoricalDate(_ dateString: String) -> Date {
        let formatter = DateFormatter()
        formatter.locale = .init(identifier: "en_US_POSIX")
        // Same formats as used in ChatSocketManager
        let formats = [
            "yyyy-MM-dd'T'HH:mm:ss.SSSSSSS'Z'",
            "yyyy-MM-dd'T'HH:mm:ss.SSSSSSS",
            "yyyy-MM-dd'T'HH:mm:ss.SSS",
            "yyyy-MM-dd'T'HH:mm:ss.SS",
            "yyyy-MM-dd'T'HH:mm:ss",
            "yyyy-MM-dd HH:mm:ss",
            "dd MMM yyyy, hh:mm a"
        ]
        
        for format in formats {
            formatter.dateFormat = format
            if let date = formatter.date(from: dateString) {
                return date
            }
        }
        return Date() // Fallback to now
    }
    
    private func handlePhotoSelection(_ item: PhotosPickerItem) {
        Task {
            if let data = try? await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                await MainActor.run {
                    self.selectedImage = image
                }
            }
        }
    }
    
    func clearSelectedImage() {
        self.selectedPhotoItem = nil
        self.selectedImage = nil
    }
}

