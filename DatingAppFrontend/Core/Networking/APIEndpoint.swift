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
    case updateProfilePicture
    case getProfileById
    case getNotifications(types: String)
    case getProfileFromNotification(targetUserId: Int)
    case updateNotificationSetting
    case getMatches
    case getNotificationSettings
    case getPrivacySettings
    case updatePrivacySettings
    case updateEmail
    case getContactDetails
    case deleteAccount
    case blockProfile
    case fetchConversationsByGroup(conversationId: Int)
    case deleteMessage
    case sendMessage
    case getBlacklistedUsers
    case unblockUser
    case deleteNotification
    
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
        case .search(let query): return "/profile/get-filtered-users/\(query)"
        case .updateLocation: return "/profile/update-location"
        case .getInbox: return "/profile/get-inbox"
        case .getMessages: return "/profile/get-messages"
        case .getMasterOptions(let type): return "/profile/get-master-options/\(type)"
        case .getInterests: return "/profile/get-interests"
        case .updateProfile: return "/profile/set-update-profile"
        case .uploadPicture: return "/profile/upload-picture"
        case .updateProfilePicture: return "/profile/update-profile"
        case .getProfileById: return "/profile/get-profile-by-id"
        case .getNotifications: return "/profile/get-notification"
        case .getProfileFromNotification: return "/profile/profile-from-notification"
        case .updateNotificationSetting: return "/profile/update-privacy-notification-setting"
        case .getMatches: return "/profile/get-matches"
        case .getNotificationSettings: return "/profile/get-privacy-notification-setting"
        case .getPrivacySettings: return "/profile/get-privacy-setting"
        case .updatePrivacySettings: return "/profile/update-privacy-setting"
        case .updateEmail: return "/auth/update-email"
        case .getContactDetails: return "/profile/get-contact-details"
        case .deleteAccount: return "/profile/delete-account"
        case .blockProfile: return "/profile/block-profile"
        case .fetchConversationsByGroup: return "/profile/get-messages-by-group"
        case .deleteMessage: return "/profile/delete-message"
        case .sendMessage: return "/profile/send-message"
        case .getBlacklistedUsers: return "/profile/blacklisted-users"
        case .unblockUser: return "/profile/unblock-profile"
        case .deleteNotification: return "/profile/delete-notification"
        }
    }
    
    nonisolated var queryItems: [URLQueryItem]? {
        switch self {
        case .getMessages(let id):
            return [URLQueryItem(name: "conversationId", value: "\(id)")]
        case .getNotifications(let types):
            return [URLQueryItem(name: "NotificationType", value: types)]
        case .fetchConversationsByGroup(let id):
            return [URLQueryItem(name: "ConversationId", value: "\(id)")]
        case .getProfileFromNotification(let id):
            return [URLQueryItem(name: "targetUserId", value: "\(id)")]
        default:
            return nil
        }
    }
    
    nonisolated var method: String {
        switch self {
        case .fetchProfile, .getAllProfiles, .search, .getInbox, .getMessages, .getMasterOptions, .getInterests, .getProfileById, .getNotifications, .getProfileFromNotification, .getMatches, .getNotificationSettings, .getPrivacySettings, .getContactDetails, .deleteAccount, .fetchConversationsByGroup, .getBlacklistedUsers: return "GET"
        case .updateLocation, .login, .register, .verifyOtp, .likeProfile, .dislikeProfile, .reportProfile, .updateProfile, .uploadPicture, .updateProfilePicture, .updateNotificationSetting, .updatePrivacySettings, .updateEmail, .blockProfile, .deleteMessage, .sendMessage, .unblockUser, .deleteNotification: return "POST"
        }
    }
}
