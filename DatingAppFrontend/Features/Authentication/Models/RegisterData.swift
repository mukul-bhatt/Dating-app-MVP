//
//  RegisterData.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 19/01/26.
//

import Foundation

// Auth error helper
enum AuthNetworkError: Error {
    case unauthorized
    case server(Int)
    case unknown
}

// Body for register call
struct Register: Codable {
    let phoneNumber: String
    let countryCode: String
}


struct SendOtpResponse: Codable {
    let success: Bool
    let message: String
    let userId: Int
    let phoneNumber: String
    let countryCode: Int
    let isNewUser: Bool
    let otp: Int

    enum CodingKeys: String, CodingKey {
        case success, message, otp
        case userId = "user_id"
        case phoneNumber = "phone_number"
        case countryCode = "country_Code"
        case isNewUser = "is_new_user"
    }
}


// MARK: - VERIFY OTP RESPONSE

struct OTPVerifyBody: Codable {
    let Mobile: String
    let countryCode: String
    let ProfileId: Int
    let Otp: String
}

// 1. The root response object
struct VerifyOtpResponse: Codable {
    let success: Bool
    let message: String
    let data: VerifyOtpData
}

// 2. The nested 'data' object
struct VerifyOtpData: Codable {
    let token: String
    let refreshToken: String
    let profileId: Int
    let countryCode: Int
    let mobile: String
    let applicationUserId: String
}
