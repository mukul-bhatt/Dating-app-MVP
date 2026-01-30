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
    case getAllProfiles
    case likeProfile
    case dislikeProfile
    case reportProfile
    
    var path: String {
        switch self {
        case .login: return "/auth/login"
        case .verifyOtp: return "/auth/verify-otp"
        case .fetchProfile: return "/profile/me"
        case .getAllProfiles: return "/profile/get-filtered-users"
        case .likeProfile: return "/profile/add-like"
        case .dislikeProfile: return "/profile/unlike"
        case .reportProfile: return "/profile/report-profile"
        }
    }
    
    var method: String {
        switch self {
        case .fetchProfile: return "GET"
        case .getAllProfiles: return "GET"
        default: return "POST"
        }
    }
}
