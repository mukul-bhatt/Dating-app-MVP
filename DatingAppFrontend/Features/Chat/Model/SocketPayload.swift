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

struct MatchStatusUser: Codable, Sendable, Identifiable {
    let userId: Int
    let name: String?
    let isOnline: Bool
    let lastSeen: Date
    let profileImage: URL?

    // Conform to Identifiable for SwiftUI lists
    var id: Int { userId }
}
