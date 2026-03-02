//
//  PrivacySettingModels.swift
//  DatingAppFrontend
//
//  Created by Antigravity on 19/02/26.
//

import Foundation

struct PrivacySettingRequest: Codable {
    let NotificationType: String
    let Show: Bool
}

struct PrivacySettingResponse: Codable {
    let success: Bool
}

struct DeleteAccountResponse: Codable {
    let success: Bool
}

struct PrivacySettingFetchResponse: Codable {
    let success: Bool
    let data: [PrivacySettingItem]
}

struct PrivacySettingItem: Codable {
    let notificationType: String
    let show: Bool
}

struct MainPrivacySettingsResponse: Codable {
    let success: Bool
    let data: MainPrivacySettingsData
}

struct MainPrivacySettingsData: Codable {
    let id: Int?
    let userId: Int?
    let displayFullName: String
    let displayAge: String
    let displayLocation: String
    let whoCanSeeYou: String
    let activityStatus: String
    let created_At: String?
    let updated_At: String?
}

struct UpdatePrivacySettingRequest: Codable {
    let DisplayFullName: String
    let DisplayAge: String
    let DisplayLocation: String
    let WhoCanSeeYou: String
    let ActivityStatus: String
}

struct UpdatePrivacySettingResponse: Codable {
    let success: Bool
    let data: [String]?
    let message: String?
}


