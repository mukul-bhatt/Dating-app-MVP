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



struct SocketChatMessage: Codable, Sendable {
    let ConversationId: Int
    let SenderId: Int
    let ReceiverId: Int
    let Message: String
    let MessageType: String
    let SentAt: Date

    enum CodingKeys: String, CodingKey {
        case ConversationId = "ConversationId"
        case SenderId = "SenderId"
        case ReceiverId = "ReceiverId"
        case Message = "Message"
        case MessageType = "MessageType"
        case SentAt = "SentAt"
    }
}

struct SocketReceivedMessage: Decodable, Sendable {
    let conversationId: Int
    let fromUserId: Int
    let toUserId: Int
    let content: String
    let type: String
    let created_At: Date
}

struct MessageHistoryResponse: Decodable, Sendable {
    let success: Bool
    let message: String
    let data: [SocketReceivedMessage]
}

struct MessageHistoryRequest: Codable, Sendable {
    let ConversationId: String
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
        case notificationType = "notificationType"
        case type = "type"
        case FromUserId = "fromUserId"
        case FromUserName = "fromUserName"
        case ToUserId = "toUserId"
        case Title = "title"
        case Body = "body"
        case Message = "message"
        case WithUserId = "WithUserId"
        case WithUserName = "WithUserName"
        case ConversationId = "ConversationId"
        case Profile = "Profile"
    }
}
