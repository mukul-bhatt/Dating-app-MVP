//
//  UserMatchResponse.swift
//  DatingAppFrontend
//
//  Created by Antigravity on 19/02/26.
//

import Foundation

// MARK: - User Matches Response
struct UserMatchResponse: Codable {
    let success: Bool
    let userId: Int?
    let totalMatches: Int?
    let data: [UserMatch]

    enum CodingKeys: String, CodingKey {
        case success
        case userId = "user_id"
        case totalMatches = "total_matches"
        case data
    }
}

// MARK: - User Match
struct UserMatch: Codable, Identifiable {
    var id: Int? { matchedUserId }
    
    let matchedUserId: Int
    let latestProfileImage: String?
    let fullName: String?
    let age: Int?
    let location: String?
    let height: String?
    let religion: String?
    let sexuality: String?
    let gender: String?
    let conversationId: Int?
    let matchId: Int? // Represented by 'id' in JSON which is null here but likely intended
    let matchUserId: Int? // Represented by 'userId' in JSON which is null here
    let contactNumber: String?
    let countryCode: String?
    let dateOfBirth: String?
    let pronouns: String?
    let bio: String?
    let job: String?
    let education: String?
    let relationshipStatus: String?
    let hope: String?
    let profileImage: String?
    let isVerify: Bool?
    let isOnline: Bool?
    let lastSeen: String?
    let provider: String?
    let providerId: String?
    let coverImage: String?
    let status: String?
    let createdAt: String?
    let updatedAt: String?
    let deletedAt: String?

    enum CodingKeys: String, CodingKey {
        case matchedUserId
        case latestProfileImage
        case fullName
        case age
        case location
        case height
        case religion
        case sexuality
        case gender
        case conversationId
        case matchId = "id"
        case matchUserId = "userId"
        case contactNumber
        case countryCode
        case dateOfBirth
        case pronouns
        case bio
        case job
        case education
        case relationshipStatus
        case hope
        case profileImage
        case isVerify = "is_Verify"
        case isOnline
        case lastSeen
        case provider
        case providerId
        case coverImage
        case status
        case createdAt = "created_At"
        case updatedAt = "updated_At"
        case deletedAt = "deleted_At"
    }
}
