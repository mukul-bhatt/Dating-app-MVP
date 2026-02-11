//
//  NotificationsManager.swift
//  DatingAppFrontend
//
//  Created by Antigravity on 10/02/26.
//

import Foundation
import Combine

@MainActor
class NotificationsManager: ObservableObject {
    /// List of notifications to be displayed on the Notifications Screen
    @Published var notifications: [AppNotification] = []
    
    /// Tracks the conversation ID of the chat currently being viewed by the user.
    /// Used to decide whether to show a global notification.
    @Published var activeConversationId: Int?
    @Published var activeReceiverId: Int?
    
    /// Count of unread notifications for tab badge
    @Published var unreadCount: Int = 0
    
    /// Cached inbox items for resolving conversation IDs during deep linking
    @Published var inboxItems: [InboxItem] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSocketListener()
    }
    
    private func setupSocketListener() {
        ChatSocketManager.shared.notificationSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self = self else { return }
                
                // Only handle "message" type for now
                if event.data.notificationType == "message" {
                    let incomingConvId = event.data.ConversationId
                    let senderId = event.data.FromUserId
                    
                    // Logic: Suppress only if we ARE in a chat AND it's THIS chat.
                    // We check BOTH conversationId and senderId (receiverId for us) 
                    // because some notifications have null conversationId initially.
                    let isUserInThisChat = (incomingConvId != nil && incomingConvId == self.activeConversationId) ||
                                           (senderId == self.activeReceiverId)
                    
                    if !isUserInThisChat {
                        self.addIncomingNotification(from: event)
                    } else {
                        print("🙈 Notification suppressed: User is focusing on sender #\(senderId)")
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private func addIncomingNotification(from event: NotificationEvent) {
        // Fix: Treat empty or whitespace profile as nil to trigger placeholders
        let profileStr = event.data.Profile.trimmingCharacters(in: .whitespacesAndNewlines)
        let profileUrl = profileStr.isEmpty ? nil : URL(string: profileStr)
        
        let newNotification = AppNotification(
            senderId: event.data.FromUserId,
            senderName: event.data.FromUserName,
            message: event.data.Message,
            senderImageUrl: profileUrl,
            conversationId: event.data.ConversationId,
            timestamp: Date()
        )
        addNotification(newNotification)
    }
    
    func addNotification(_ notification: AppNotification) {
        // Add to the top of the list
        self.notifications.insert(notification, at: 0)
        self.unreadCount += 1
        print("🔔 Global alert added: \(notification.message) | Total unread: \(unreadCount)")
    }
    
    func clearUnreadCount() {
        self.unreadCount = 0
    }

    func clearAll() {
        notifications.removeAll()
        unreadCount = 0
        activeConversationId = nil
        activeReceiverId = nil
    }
}
