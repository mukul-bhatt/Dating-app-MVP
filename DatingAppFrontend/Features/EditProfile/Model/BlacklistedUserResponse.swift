//
//  BlacklistedUserResponse.swift
//  DatingAppFrontend
//
//  Created by Antigravity on 24/02/26.
//

import Foundation

// MARK: - Blacklisted Users Response
struct BlacklistedUserResponse: Codable {
    let success: Bool
    let message: String
    let data: [BlacklistedUser]
}

// MARK: - Blacklisted User
struct BlacklistedUser: Codable, Identifiable, Hashable {
    var id: Int { blacklistedUserId }
    
    let toUserId: Int
    let status: String?
    let fromUserId: Int
    let createdAt: String?
    let blacklistedUserId: Int
    let latestProfileImage: String?
    let profilePicture: String?
    let fullName: String?
    let age: Int?
    let location: String?
    let height: String?
    let religion: String?
    let sexuality: String?
    let gender: String?
    let conversationId: Int?
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
    let updatedAt: String?
    let deletedAt: String?

    enum CodingKeys: String, CodingKey {
        case toUserId
        case status
        case fromUserId
        case createdAt = "created_At"
        case blacklistedUserId
        case latestProfileImage
        case profilePicture
        case fullName
        case age
        case location
        case height
        case religion
        case sexuality
        case gender
        case conversationId
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
        case updatedAt = "updated_At"
        case deletedAt = "deleted_At"
    }
}

// MARK: - Unblock Request
struct UnblockRequest: Codable {
    let toUserId: String
    let status: String
}

// MARK: - Generic Response
struct GenericResponse: Codable {
    let success: Bool
    let message: String?
}
