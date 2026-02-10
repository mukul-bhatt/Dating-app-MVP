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
    @Published var lastMessageId: UUID?
    @Published var messages: [Message] = []
    @Published var messageFieldValue: String = ""
    
    // Track current session details
    private var userId: Int?
    private var conversationId: Int?
    private var receiverId: Int?
    @Published var receiverName: String = "Nia Sharma" // default placeholder
    @Published var receiverImageURL: URL?
    
    private var cancellables = Set<AnyCancellable>()

    init() {
        // Mock messages removed to support dynamic history and empty states
        self.messages = []
    }

    func sendGreeting() {
        self.messageFieldValue = "Hi! 👋"
        sendMessage()
    }

    func connect(userId: Int, conversationId: Int, receiverId: Int, name: String? = nil, imageURL: URL? = nil) {
        self.userId = userId
        self.conversationId = conversationId
        self.receiverId = receiverId
        self.receiverName = name ?? "Chat"
        self.receiverImageURL = imageURL
        
        // 2. Fetch History
        fetchMessageHistory(conversationId: conversationId)
        
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
        
        // 2. Connect via Manager
        ChatSocketManager.shared.connect(userId: userId)
    }
    
    func sendMessage() {
        let text = messageFieldValue
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        guard let userId = userId, let conversationId = conversationId, let receiverId = receiverId else {
            print("❌ Cannot send message: Missing session info")
            return
        }

//        let text = messageFieldValue
        let localMessage = Message(text: text, isFromMe: true)
        
        // 1. Add to local UI
        messages.append(localMessage)
        messageFieldValue = ""
        self.lastMessageId = localMessage.id
        
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
                let response: MessageHistoryResponse = try await NetworkManager.shared.request(endpoint: .getMessages(conversationId: conversationId))
                
                if response.success {
                    // Convert historical messages to our UI Message type
                    // Logic: Backend seems to use toUserId as a source field for history.
                    // If toUserId == myId, then I am the sender.
                    let historicalMessages = response.data.map { msg in
                        Message(text: msg.content, isFromMe: msg.toUserId == self.userId)
                    }
                    
                    await MainActor.run {
                        print("📜 Loaded \(historicalMessages.count) historical messages")
                        // Replace current messages with history
                        self.messages = historicalMessages
                        
                        // Scroll to bottom if there are messages
                        if let lastMessage = historicalMessages.last {
                            self.lastMessageId = lastMessage.id
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
        
        // Convert socket message to our local Message type
        let newMessage = Message(text: receivedMessage.content, isFromMe: false)
        
        // Append to UI list
        DispatchQueue.main.async {
            self.messages.append(newMessage)
            self.lastMessageId = newMessage.id
        }
    }
    
    func handleSentAcknowledgment(_ socketMessage: SocketChatMessage) {
        // This is an echo/ack of our own message
        print("✅ Message successfully processed by server")
        // We could update a 'delivered' status here if we had one
    }
    
    func handleIncomingNotification(_ notification: NotificationEvent) {
        if notification.data.notificationType == "message" {
            // Check if this notification is for the current conversation
            if let incomingConvId = notification.data.ConversationId, incomingConvId == self.conversationId {
                let newMessage = Message(text: notification.data.Message, isFromMe: false)
                messages.append(newMessage)
                self.lastMessageId = newMessage.id
            }
        }
    }
}

