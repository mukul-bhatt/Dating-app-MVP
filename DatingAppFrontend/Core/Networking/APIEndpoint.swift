//
//  APIEndpoint.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 21/01/26.
//


enum APIEndpoint {
    case login
    case verifyOtp
    case fetchProfile
    
    var path: String {
        switch self {
        case .login: return "/auth/login"
        case .verifyOtp: return "/auth/verify-otp"
        case .fetchProfile: return "/profile/me"
        }
    }
    
    var method: String {
        switch self {
        case .fetchProfile: return "GET"
        default: return "POST"
        }
    }
}
