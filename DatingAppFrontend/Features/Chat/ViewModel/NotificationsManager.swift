//
//  NotificationsManager.swift
//  DatingAppFrontend
//
//  Created by Antigravity on 10/02/26.
//

import Foundation
import Combine
import SwiftUI

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
    @Published var unreadMessageCount: Int = 0

    
    /// Cached inbox items for resolving conversation IDs during deep linking
    @Published var inboxItems: [InboxItem] = []
    
    /// Properties for handling the match screen
    @Published var showMatchScreen: Bool = false
    @Published var latestMatch: NotificationData? = nil
    
    /// Navigation Properties for central control
    @Published var selectedTab: Int = 0
    @Published var chatPath = NavigationPath()
    
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
                let type = event.data.notificationType ?? event.data.type
                
                if type == "like" || type == "match" {
                    // 🚀 Handle real-time match screen
                    if type == "match" {
                        print("🔥 Real-time MATCH received!")
                        self.latestMatch = event.data
                        self.showMatchScreen = true
                    }
                    
                    // 🔄 Refresh historical notifications from API to ensure consistent IDs and avoid duplication
                    Task {
                        await self.fetchHistoricalNotifications()
                    }
                }
            }
            .store(in: &cancellables)
            
        // 🚀 Observe foreground events to ensure counts are fresh when user returns
        NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                print("📱 App foregrounded, requesting counts...")
                self?.requestUnreadCounts()
            }
            .store(in: &cancellables)


        ChatSocketManager.shared.connectionStatusSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isConnected in
                if isConnected {
                    print("🔗 Socket connected, requesting unread counts...")
                    self?.requestUnreadCounts()
                }
            }
            .store(in: &cancellables)
            
        ChatSocketManager.shared.countEventSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] payload in
                if payload.type == "unread_count" {
                    print("🔔 Updating unreadCount to: \(payload.count)")
                    self?.unreadCount = payload.count
                } else if payload.type == "unread_message_count" {
                    print("💬 Updating unreadMessageCount to: \(payload.count)")
                    self?.unreadMessageCount = payload.count
                }
            }
            .store(in: &cancellables)
    }
    
    func requestUnreadCounts() {
        print("🔄 Requesting fresh counts from WebSocket...")
        ChatSocketManager.shared.sendRawMessage("unreadCount")
        ChatSocketManager.shared.sendRawMessage("unreadMessageCount")
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
            notificationType: event.data.notificationType ?? event.data.type
        )
        addNotification(newNotification)
    }
    
    func addNotification(_ notification: AppNotification) {
        // Avoid duplicate ID if socket sends what API already fetched
        guard !notifications.contains(where: { $0.id == notification.id }) else { return }
        
        self.notifications.insert(notification, at: 0)
        
        // Instead of local increment, request accurate state from server
        requestUnreadCounts()
        print("🔔 Global alert added: \(notification.body). Requesting fresh counts.")
    }
    
    func clearUnreadCount() {
        // We still reset locally for instant UI feedback
        self.unreadCount = 0
        self.unreadMessageCount = 0
        
        // But also notify the server if possible, or request fresh (empty) counts
        requestUnreadCounts()
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
    
    func deleteNotification(notificationId: Int) async {
        let body = DeleteNotificationRequest(notificationId: String(notificationId))
        
        do {
            let response: DeleteNotificationResponse = try await NetworkManager.shared.request(
                endpoint: .deleteNotification,
                body: body
            )
            
            if response.success {
                print("✅ Notification deleted successfully: \(notificationId)")
                await MainActor.run {
                    self.notifications.removeAll { $0.id == notificationId }
                    // Recalculate unreadCount based on remaining notifications that are unread
                    // Note: AppNotification currently doesn't store unread status, 
                    // but we can decrement if it was in the list.
                    // The API fetchHistoricalNotifications calculates it from NotificationItem.notificationStatus.
                }
            } else {
                print("❌ Notification deletion failed: \(response.data.message)")
            }
        } catch {
            print("❌ Notification deletion error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Navigation Control
    
    func openChatForMatch(data: NotificationData) {
        // 1. Dismiss match screen
        self.showMatchScreen = false
        
        // 2. Clear current chat path to ensure a fresh push
        self.chatPath = NavigationPath()
        
        // 3. Construct InboxItem from NotificationData
        let item = InboxItem(
            conversationId: data.ConversationId ?? 0,
            profileId: data.WithUserId ?? 0,
            userName: data.WithUserName,
            firstName: "", // Optional in ChatView
            lastName: "",  // Optional in ChatView
            lastMessage: "",
            lastMessageTime: "",
            profile: URL(string: data.Profile),
            profilePicture: URL(string: data.Profile),
            isBlocked: false,
            unreadCount: 0
        )
        
        // 4. Switch to Chat Tab (index 1)
        self.selectedTab = 1
        
        // 5. Append Route to Path
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.chatPath.append(ChatRoute.chat(item))
            print("🔀 Navigating to Chat for user: \(data.WithUserName)")
        }
    }
}
