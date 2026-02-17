//
//  AppNotification.swift
//  DatingAppFrontend
//
//  Created by Antigravity on 10/02/26.
//

import Foundation

struct AppNotification: Identifiable, Sendable {
    var id = Int.random(in: 1...Int.max) // Use Int for ID to match API if possible, or keep UUID
    let senderId: Int
    let senderName: String
    let message: String
    let senderImageUrl: URL?
    let conversationId: Int?
    let timestamp: Date
    let notificationType: String // "message", "like", "match"
}


struct AppNotificationViaApi: Codable{
    let success: Bool
    let data: [NotificationItem]
}


struct NotificationItem: Codable, Identifiable {
    let id: Int
    let userId: Int
    let notificationName: String
    let notificationType: String
    let notificationStatus: Bool
    let notificationBody: String
    let senderUserId: Int
    let withUserId: Int?
    let conversationId: Int?
    let firstName: String
    let lastName: String?
    let profile: String
    let status: String
    let createdAt: String
    let updatedAt: String
    let deletedAt: String

    // CodingKeys handle the mismatch between JSON snake_case and Swift camelCase
    enum CodingKeys: String, CodingKey {
        case id, userId, notificationName, notificationType, notificationStatus
        case notificationBody, senderUserId, withUserId, conversationId
        case firstName, lastName, profile, status
        case createdAt = "created_At"
        case updatedAt = "updated_At"
        case deletedAt = "deleted_At"
    }
}
