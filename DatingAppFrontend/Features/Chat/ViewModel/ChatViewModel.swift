//
//  ChatViewModel.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 04/02/26.
//

import Foundation
import Combine




class ChatViewModel: ObservableObject
{
    @Published var lastMessageId: String? // Changed to String to support both UUID and Int IDs
    @Published var groupedMessages: [DateGroup] = []
    @Published var messageFieldValue: String = ""
    
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
        
        // Removed: ChatSocketManager.shared.connect(userId: userId)
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
            toUserId: receiverId,
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
        
        // 2. Send via Socket
        let socketMessage = SocketChatMessage(
            ConversationId: conversationId,
            SenderId: userId,
            ReceiverId: receiverId,
            Message: text,
            MessageType: "text",
            SentAt: Date()
        )
        
        ChatSocketManager.shared.sendMessage(payload: socketMessage)
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
            toUserId: self.userId ?? 0,
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
        if notification.data.notificationType == "message" {
            let incomingConvId = notification.data.ConversationId
            let senderId = notification.data.FromUserId
            
            // Match logic: Same conversation ID OR same sender (if no ID yet)
            let isCurrentConv = (incomingConvId != nil && incomingConvId == self.conversationId)
            let isFromCurrentReceiver = (senderId == self.receiverId)
            
            if isCurrentConv || isFromCurrentReceiver {
                let chatMsg = ChatMessage(
                    id: Int.random(in: 100000...999999),
                    type: "text",
                    toUserId: self.userId ?? 0,
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
            return response.success
        } catch {
            print("❌ Failed to block user: \(error)")
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
}

