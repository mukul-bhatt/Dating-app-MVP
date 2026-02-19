//
//  SettingsViewModel.swift
//  DatingAppFrontend
//
//  Created by Antigravity on 19/02/26.
//

import Foundation
import Combine

@MainActor
class SettingsViewModel: ObservableObject {
    @Published var matchNotification = true
    @Published var messageNotification = true
    @Published var emailNotification = true
    @Published var smsNotification = false
    @Published var likeNotification = true
    
    // Privacy Settings
    @Published var displayFullName = "Everyone"
    @Published var displayAge = "Everyone"
    @Published var displayLocation = "Everyone"
    @Published var whoCanSeeYou = "Everyone"
    @Published var activityStatus = "Everyone"
    
    @Published var isUpdating = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showAlert = false
    
    func fetchNotificationSettings() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response: PrivacySettingFetchResponse = try await NetworkManager.shared.request(
                endpoint: .getNotificationSettings
            )
            
            if response.success {
                for item in response.data {
                    switch item.notificationType {
                    case "MatchNotification":
                        self.matchNotification = item.show
                    case "MessageNotification":
                        self.messageNotification = item.show
                    case "EmailNotification":
                        self.emailNotification = item.show
                    case "SMSNotification":
                        self.smsNotification = item.show
                    case "Notification":
                        self.likeNotification = item.show
                    default:
                        break
                    }
                }
                print("✅ Successfully fetched notification settings")
            } else {
                errorMessage = "Failed to fetch settings"
                print("❌ Failed to fetch notification settings")
            }
        } catch {
            errorMessage = error.localizedDescription
            print("❌ Error fetching notification settings: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    func fetchPrivacySettings() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response: MainPrivacySettingsResponse = try await NetworkManager.shared.request(
                endpoint: .getPrivacySettings
            )
            
            if response.success {
                self.displayFullName = mapApiResponseToUi(response.data.displayFullName)
                self.displayAge = mapApiResponseToUi(response.data.displayAge)
                self.displayLocation = mapApiResponseToUi(response.data.displayLocation)
                self.whoCanSeeYou = mapApiResponseToUi(response.data.whoCanSeeYou)
                self.activityStatus = mapApiResponseToUi(response.data.activityStatus)
                print("✅ Successfully fetched privacy settings")
            } else {
                errorMessage = "Failed to fetch privacy settings"
                print("❌ Failed to fetch privacy settings")
            }
        } catch {
            errorMessage = error.localizedDescription
            print("❌ Error fetching privacy settings: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    private func mapApiResponseToUi(_ value: String) -> String {
        switch value {
        case "EveryOne": return "Everyone"
        case "OnlyMyMatches": return "Only my Matches"
        case "Nobody": return "Nobody"
        default: return value
        }
    }
    
    func updateNotificationSetting(type: String, show: Bool) async {
        isUpdating = true
        errorMessage = nil
        
        let body = PrivacySettingRequest(NotificationType: type, Show: show)
        
        do {
            let response: PrivacySettingResponse = try await NetworkManager.shared.request(
                endpoint: .updateNotificationSetting,
                body: body
            )
            
            if response.success {
                print("✅ Successfully updated \(type) to \(show)")
            } else {
                errorMessage = "Failed to update \(type)"
                print("❌ Failed to update \(type)")
            }
        } catch {
            errorMessage = error.localizedDescription
            print("❌ Error updating \(type): \(error.localizedDescription)")
        }
        
        isUpdating = false
    }
    
    func updatePrivacySettings() async {
        isUpdating = true
        errorMessage = nil
        
        let body = UpdatePrivacySettingRequest(
            DisplayFullName: mapUiToApi(displayFullName),
            DisplayAge: mapUiToApi(displayAge),
            DisplayLocation: mapUiToApi(displayLocation),
            WhoCanSeeYou: mapUiToApi(whoCanSeeYou),
            ActivityStatus: mapUiToApi(activityStatus)
        )
        
        do {
            let response: UpdatePrivacySettingResponse = try await NetworkManager.shared.request(
                endpoint: .updatePrivacySettings,
                body: body
            )
            
            if response.success {
                print("✅ Successfully updated privacy settings")
            } else {
                errorMessage = response.message ?? "Failed to update privacy settings"
                showAlert = true
                print("❌ Failed to update privacy settings: \(errorMessage ?? "")")
            }
        } catch {
            errorMessage = error.localizedDescription
            showAlert = true
            print("❌ Error updating privacy settings: \(error.localizedDescription)")
        }
        
        isUpdating = false
    }
    
    private func mapUiToApi(_ value: String) -> String {
        switch value {
        case "Everyone": return "EveryOne"
        case "Only my Matches": return "OnlyMyMatches"
        case "Nobody": return "Nobody"
        default: return value
        }
    }
}
