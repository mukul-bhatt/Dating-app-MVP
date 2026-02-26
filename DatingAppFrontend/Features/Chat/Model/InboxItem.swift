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

struct InboxItem: Codable, Identifiable, Sendable, Hashable, Equatable {
    let conversationId: Int
    let profileId: Int
    let userName: String
    let firstName: String
    let lastName: String
    let lastMessage: String
    let lastMessageTime: String
    let profilePicture: String?
    let isBlocked: Bool
    let unreadCount: Int
    
    var profilePictureURL: URL? {
        guard let profilePicture = profilePicture, !profilePicture.isEmpty else { return nil }
        return URL(string: profilePicture)
    }
    
    var id: Int { conversationId }
}
