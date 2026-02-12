//
//  APIEndpoint.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 21/01/26.
//

import Foundation

enum APIEndpoint {
    case login
    case register
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
    case getMasterOptions(type: String)
    case getInterests
    case updateProfile
    case uploadPicture
    case getProfileById
    
    nonisolated var path: String {
        switch self {
        case .login: return "/auth/login"
        case .register: return "/auth/register"
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
        case .getMasterOptions(let type): return "/profile/get-master-options/\(type)"
        case .getInterests: return "/profile/get-interests"
        case .updateProfile: return "/profile/set-update-profile"
        case .uploadPicture: return "/profile/upload-picture"
        case .getProfileById: return "/profile/get-profile-by-id"
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
        case .fetchProfile, .getAllProfiles, .search, .getInbox, .getMessages, .getMasterOptions, .getInterests, .getProfileById: return "GET"
        case .updateLocation, .login, .register, .verifyOtp, .likeProfile, .dislikeProfile, .reportProfile, .updateProfile, .uploadPicture: return "POST"
        }
    }
}
