//
//  OTPVerificationResponse.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 20/01/26.
//


struct OTPVerificationResponse: Codable {
    let success: Bool
    let message: String
    let data: TokenData
}

struct TokenData: Codable {
    let token: String
    let refreshToken: String
    let profileId: Int
    let countryCode: Int
    let mobile: String
    let applicationUserId: String
}