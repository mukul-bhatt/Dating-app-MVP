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
    let timestamp: Date
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

    // These keys are used when WE encode to send to the server
    enum CodingKeys: String, CodingKey {
        case ConversationId = "conversationId"
        case SenderId = "senderId"
        case ReceiverId = "receiverId"
        case Message = "content"
        case MessageType = "type"
        case SentAt = "sentAt"
    }
}

// Used for decoding the server's PascalCase acknowledgment
struct SentAckEvent: Decodable, Sendable {
    let ConversationId: Int?
    let SenderId: Int?
    let ReceiverId: Int?
    let Message: String?
    let MessageType: String?
}

struct SocketReceivedMessage: Decodable, Sendable {
    let conversationId: Int
    let fromUserId: Int
    let toUserId: Int
    let content: String
    let type: String
    let created_At: Date
}

struct HistoricalMessage: Decodable, Sendable {
    let type: String
    let toUserId: Int
    let conversationId: Int
    let isRead: Bool
    let readAt: String
    let status: String
    let content: String
    let created_At: String
}

struct MessageHistoryResponse: Decodable, Sendable {
    let success: Bool
    let message: String
    let data: [HistoricalMessage]
}


struct NotificationEvent: Decodable, Sendable {
    let type: String
    let data: NotificationData
}

struct NotificationData: Decodable, Sendable {
    let notificationType: String?
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



// MARK: - Conversations By Group Response
struct ConversationResponse: Codable {
    let success: Bool
    let message: String
    let isBlocked: Bool
    let data: [DateGroup]
}

// MARK: - Date Group
struct DateGroup: Codable, Identifiable {
    let id = UUID()   // for SwiftUI lists

    let dateGroup: String
    let messageDate: String
    let messages: [ChatMessage]

    enum CodingKeys: String, CodingKey {
        case dateGroup
        case messageDate
        case messages
    }
}

// MARK: - Message
struct ChatMessage: Codable, Identifiable {
    let id: Int
    let type: String
    let toUserId: Int
    let conversationId: Int
    let isRead: Bool
    let readAt: String
    let status: String
    let content: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case type
        case toUserId
        case conversationId
        case isRead
        case readAt
        case status
        case content
        case createdAt = "created_At"
    }
}
