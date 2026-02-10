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
    
    func addNotification(_ notification: AppNotification) {
        // Add to the top of the list
        self.notifications.insert(notification, at: 0)
    }
    
    func clearAll() {
        notifications.removeAll()
    }
}
