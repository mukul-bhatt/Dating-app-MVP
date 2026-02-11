//
//  AppNotification.swift
//  DatingAppFrontend
//
//  Created by Antigravity on 10/02/26.
//

import Foundation

struct AppNotification: Identifiable, Sendable {
    let id = UUID()
    let senderId: Int
    let senderName: String
    let message: String
    let senderImageUrl: URL?
    let conversationId: Int?
    let timestamp: Date
}
