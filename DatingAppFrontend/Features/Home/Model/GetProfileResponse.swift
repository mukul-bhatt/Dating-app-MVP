//
//  GetProfileResponse.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 27/01/26.
//

import Foundation

struct GetProfileResponse: Codable {
    let success: Bool
    let userId: Int
    let data: [DiscoverProfile]

    enum CodingKeys: String, CodingKey {
        case success
        case userId = "user_id" // Mapping snake_case from JSON to camelCase
        case data
    }
}

struct DiscoverProfile: Codable, Identifiable {
    let id: Int
    let fullName: String
    let gender: String
    let bio: String
    let job: String
    let displayAge: String
    let education: String
    let height: String
    let hopeText: String
    let displayLocation: String
    let matchPercent: String
    let interestsArray: [String]
    let isLikedByMe: Bool
    let sexualityText: String
    let pronounsText: String
    let religionText: String
    let relationshipText: String
    let distanceInKM: String
    let profileImagesArray: [String]
}
