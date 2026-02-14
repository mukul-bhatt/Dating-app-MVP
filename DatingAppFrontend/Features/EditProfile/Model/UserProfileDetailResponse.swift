//
//  UserProfileDetailResponse.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 12/02/26.
//

import Foundation

// MARK: - Get Single User Profile Response
struct UserProfileDetailResponse: Codable {
    let success: Bool
    let message: String
    let data: UserProfileDataWrapper
}

struct UserProfileDataWrapper: Codable {
    let profile: UserProfileDetail
}

struct UserProfileDetail: Codable {
    let id: Int
    let firstName: String
    let lastName: String
    let userId: String
    let contactNumber: String
    let countryCode: Int
    let email: String
    let gender: String
    let dateOfBirth: String
    let pronouns: LookupValue?
    let sexuality: LookupValue?
    let bio: String
    let religion: LookupValue?
    let age: String
    let job: String
    let education: String
    let height: String
    let relationshipStatus: LookupValue?
    let hope: LookupValue?
    let preferredAge: String
    let preferredReligion: [LookupValue]
    let preferredSexuality: [LookupValue]
    let location: String
    let latitude: String
    let longitude: String
    let preferredRange: String
    let interests: [String]
    let imageProfiles: [String]
    let profilePicture: String
}

struct LookupValue: Codable {
    let id: Int
    let value: String
}
