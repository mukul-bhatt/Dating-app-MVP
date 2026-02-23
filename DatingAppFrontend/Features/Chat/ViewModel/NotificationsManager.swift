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
    
    /// Properties for handling the match screen
    @Published var showMatchScreen: Bool = false
    @Published var latestMatch: NotificationData? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSocketListener()
    }
    
    func fetchHistoricalNotifications() async {
        do {
            let response: AppNotificationViaApi = try await NetworkManager.shared.request(
                endpoint: .getNotifications(types: "match,like")
            )
            
            if response.success {
                let historical = response.data.map { item in
                    AppNotification(
                        id: item.id,
                        senderId: item.senderUserId ?? 0,
                        senderName: item.firstName,
                        body: item.notificationBody,
                        senderImageUrl: URL(string: item.profile),
                        conversationId: item.conversationId,
                        targetUserId: item.withUserId ?? item.senderUserId ?? 0,
                        timestamp: ISO8601DateFormatter().date(from: item.createdAt) ?? Date(),
                        notificationType: item.notificationType
                    )
                }
                  
                await MainActor.run {
                    // Calculate unread count from historical notifications (where status is true/unread)
                    let unreadHistorical = response.data.filter { $0.notificationStatus == true }.count
                    self.unreadCount = unreadHistorical
                    
                    // Merge avoiding duplicates (by id)
                    for notification in historical {
                        if !self.notifications.contains(where: { $0.id == notification.id }) {
                            self.notifications.append(notification)
                        }
                    }
                    // Sort by timestamp descending
                    self.notifications.sort(by: { $0.timestamp > $1.timestamp })
                }
            }
        } catch {
            print("❌ Error fetching historical notifications: \(error)")
        }
    }
    
    private func setupSocketListener() {
        ChatSocketManager.shared.notificationSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self = self else { return }
                
                // Handle various types from WebSocket
                let type = event.data.notificationType
                
                if type == "message" || type == "like" || type == "match" {
                    // 🚀 Handle real-time match screen
                    if type == "match" {
                        print("🔥 Real-time MATCH received!")
                        self.latestMatch = event.data
                        self.showMatchScreen = true
                    }
                    
                    let incomingConvId = event.data.ConversationId
                    let senderId = event.data.FromUserId
                    
                    // Logic: Suppress only message notifications if we ARE in that chat already
                    let isUserInThisChat = type == "message" && (
                        (incomingConvId != nil && incomingConvId == self.activeConversationId) ||
                        (senderId == self.activeReceiverId)
                    )
                    
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
        let profileStr = event.data.Profile.trimmingCharacters(in: .whitespacesAndNewlines)
        let profileUrl = profileStr.isEmpty ? nil : URL(string: profileStr)
        
        let newNotification = AppNotification(
            senderId: event.data.FromUserId,
            senderName: event.data.FromUserName,
            body: event.data.Body,
            senderImageUrl: profileUrl,
            conversationId: event.data.ConversationId,
            targetUserId: event.data.WithUserId ?? 0,
            timestamp: Date(),
            notificationType: event.data.notificationType ?? ""
        )
        addNotification(newNotification)
    }
    
    func addNotification(_ notification: AppNotification) {
        // Avoid duplicate ID if socket sends what API already fetched
        guard !notifications.contains(where: { $0.id == notification.id }) else { return }
        
        self.notifications.insert(notification, at: 0)
        self.unreadCount += 1
        print("🔔 Global alert added: \(notification.body) | Total unread: \(unreadCount)")
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

    func acceptLikeRequest(notification: AppNotification) async {
        let body = sendLike(toUserId: notification.senderId, action: "Accept")
        
        do {
            let response: likeResponse = try await NetworkManager.shared.request(
                endpoint: .likeProfile,
                body: body
            )
            
            if response.success {
                print("✅ Accept successful: \(response.message)")
                // Remove notification from list as it's now handled
                await MainActor.run {
                    self.notifications.removeAll { $0.id == notification.id }
                    if self.unreadCount > 0 {
                        self.unreadCount -= 1
                    }
                }
            } else {
                print("❌ Accept failed: \(response.message)")
            }
        } catch {
            print("❌ Accept error: \(error.localizedDescription)")
        }
    }

    func declineLikeRequest(notification: AppNotification) async {
        let body = sendLike(toUserId: notification.senderId, action: "Decline")
        
        do {
            let response: likeResponse = try await NetworkManager.shared.request(
                endpoint: .likeProfile,
                body: body
            )
            
            if response.success {
                print("✅ Decline successful: \(response.message)")
                // Remove notification from list as it's now handled
                await MainActor.run {
                    self.notifications.removeAll { $0.id == notification.id }
                    if self.unreadCount > 0 {
                        self.unreadCount -= 1
                    }
                }
            } else {
                print("❌ Decline failed: \(response.message)")
            }
        } catch {
            print("❌ Decline error: \(error.localizedDescription)")
        }
    }

    func fetchProfileFromNotification(userId: Int) async throws -> DiscoverProfile {
        let response: NotificationProfileResponse = try await NetworkManager.shared.request(
            endpoint: .getProfileFromNotification(targetUserId: userId)
        )
        
        guard response.success else {
            throw NSError(domain: "NotificationsManager", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch profile"])
        }
        
        return response.data
    }
}
