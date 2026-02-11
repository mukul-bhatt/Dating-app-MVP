//
//  SocketPayload.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 05/02/26.
//

import Foundation


struct MatchStatusEvent: Codable, Sendable {
    let type: String
    let users: [MatchStatusUser]
}

struct MatchStatusSingleEvent: Codable, Sendable {
    let type: String
    let userId: Int
    let isOnline: Bool
    let lastSeen: Date
}

struct MatchStatusUser: Codable, Sendable, Identifiable {
    let userId: Int
    let name: String?
    let isOnline: Bool
    let lastSeen: Date
    let profileImage: URL?

    // Conform to Identifiable for SwiftUI lists
    var id: Int { userId }
}
