//
//  ContactDetails.swift
//  DatingAppFrontend
//
//  Created by Antigravity on 20/02/26.
//

import Foundation

struct ContactDetailsResponse: Codable {
    let success: Bool
    let data: [ContactData]
}

struct ContactData: Codable {
    let id: Int
    let phoneNumber: String
    let countryCode: String
    let profileId: Int?
    let email: String
}
