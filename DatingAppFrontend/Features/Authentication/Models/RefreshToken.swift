//
//  RefreshToken.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 21/01/26.
//

import Foundation

struct RefreshTokenApiBody: Codable{
    let token: String
    let refreshToken: String
}

struct RefreshTokenResponse: Codable {
    let success: Bool
    let token: String
    let expires: String
    let refreshToken: String
}
