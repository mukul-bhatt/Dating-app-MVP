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


extension DiscoverProfile {
    static let mock = DiscoverProfile(
        id: 12184,
        fullName: "Nia Sharma",
        gender: "Female",
        bio: "Architecture student who loves coffee, trekking, and indie music. Looking for someone to explore the hidden gems of Delhi with!",
        job: "Architectural Intern",
        displayAge: "23",
        education: "School of Planning and Architecture",
        height: "168",
        hopeText: "I'm hoping to find someone who appreciates art as much as I do.",
        displayLocation: "Hauz Khas, Delhi",
        matchPercent: "92",
        interestsArray: ["Architecture", "Coffee", "Hiking", "Photography", "Sketching"],
        isLikedByMe: false,
        sexualityText: "Straight",
        pronounsText: "She/Her",
        religionText: "Hindu",
        relationshipText: "Single",
        distanceInKM: "4.2",
        profileImagesArray: [
            "https://images.pexels.com/photos/1587009/pexels-photo-1587009.jpeg",
            "https://images.pexels.com/photos/733872/pexels-photo-733872.jpeg",
            "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg"
        ]
    )
    
    // An array of mocks for testing lists/scrollviews
    static let mockArray = [
        mock,
        DiscoverProfile(
            id: 12185,
            fullName: "Aman Gupta",
            gender: "Male",
            bio: "Tech enthusiast and marathon runner. I make a mean butter chicken.",
            job: "Software Engineer",
            displayAge: "26",
            education: "IIT Delhi",
            height: "180",
            hopeText: "Looking for a partner in crime for weekend runs.",
            displayLocation: "Gurgaon",
            matchPercent: "78",
            interestsArray: ["Running", "Coding", "Cooking"],
            isLikedByMe: true,
            sexualityText: "Straight",
            pronounsText: "He/Him",
            religionText: "Sikh",
            relationshipText: "Single",
            distanceInKM: "12.0",
            profileImagesArray: ["https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg"]
        )
    ]
}
