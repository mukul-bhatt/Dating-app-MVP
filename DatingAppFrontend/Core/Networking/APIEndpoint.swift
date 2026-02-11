//
//  APIEndpoint.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 21/01/26.
//

import Foundation

enum APIEndpoint {
    case login
    case verifyOtp
    case fetchProfile
    case getAllProfiles
    case likeProfile
    case dislikeProfile
    case reportProfile
    case search(query: String)
    case updateLocation
    case getInbox
    case getMessages(conversationId: Int)
    
    nonisolated var path: String {
        switch self {
        case .login: return "/auth/login"
        case .verifyOtp: return "/auth/verify-otp"
        case .fetchProfile: return "/profile/me"
        case .getAllProfiles: return "/profile/get-filtered-users"
        case .likeProfile: return "/profile/add-like"
        case .dislikeProfile: return "/profile/unlike"
        case .reportProfile: return "/profile/report-profile"
        case .search(let query): return "/profile/search\(query)"
        case .updateLocation: return "/profile/update-location"
        case .getInbox: return "/profile/get-inbox"
        case .getMessages: return "/profile/get-messages"
        }
    }
    
    nonisolated var queryItems: [URLQueryItem]? {
        switch self {
        case .getMessages(let id):
            return [URLQueryItem(name: "conversationId", value: "\(id)")]
        default:
            return nil
        }
    }
    
    nonisolated var method: String {
        switch self {
        case .fetchProfile, .getAllProfiles, .search, .getInbox, .getMessages: return "GET"
        case .updateLocation: return "POST"
        default: return "POST"
        }
    }
}
