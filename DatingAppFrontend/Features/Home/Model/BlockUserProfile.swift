//
//  BlockUserProfile.swift
//  DatingAppFrontend
//
//  Created by Antigravity on 23/02/26.
//

import Foundation

struct BlockUserRequest: Codable {
    let toUserId: String
    let status: String
}

struct BlockUserResponse: Codable {
    let success: Bool
    let message: String?
}
