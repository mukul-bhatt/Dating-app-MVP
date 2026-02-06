//
//  Message.swift
//  DatingAppFrontend
//
//  Created by Antigravity on 04/02/26.
//

import Foundation

struct Message: Identifiable, Sendable {
    let id = UUID()
    let text: String
    let isFromMe: Bool
}

struct SocketTypeEnvelope: Decodable, Sendable {
    let type: String?
}



struct SocketChatMessage: Decodable, Sendable {
    let ConversationId: Int
    let SenderId: Int
    let ReceiverId: Int
    let Message: String
    let MessageType: String
    let SentAt: Date
}


struct NotificationEvent: Decodable, Sendable {
    let type: String
    let data: NotificationData
}

struct NotificationData: Decodable, Sendable {
    let notificationType: String
    let type: String
    let FromUserId: Int
    let FromUserName: String
    let ToUserId: Int
    let Title: String
    let Body: String
    let Message: String
    let WithUserId: Int?
    let WithUserName: String
    let ConversationId: Int?
    let Profile: String

    enum CodingKeys: String, CodingKey {
        case notificationType = "NotificationType"
        case type = "Type"
        case FromUserId, FromUserName, ToUserId, Title, Body, Message, WithUserId, WithUserName, ConversationId, Profile
    }
}
