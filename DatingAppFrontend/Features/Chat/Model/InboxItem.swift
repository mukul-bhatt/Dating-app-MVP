//
//  InboxItem.swift
//  DatingAppFrontend
//
//  Created by Antigravity on 06/02/26.
//

import Foundation

struct InboxResponse: Codable, Sendable {
    let success: Bool
    let data: [InboxItem]
}

struct InboxItem: Codable, Identifiable, Sendable {
    let conversationId: Int
    let profileId: Int
    let userName: String
    let firstName: String
    let lastName: String
    let lastMessage: String
    let lastMessageTime: String
    let profile: URL?
    let isBlocked: Bool
    
    var id: Int { conversationId }
}
