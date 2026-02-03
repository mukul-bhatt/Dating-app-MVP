//
//  DiscoverViewModel.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 27/01/26.
//

import Foundation
import Combine
import PhotosUI

enum SwipeDirection {
    case left
    case right
}

class DiscoverViewModel: ObservableObject {
    @Published var users: [DiscoverProfile] = []
    @Published var isLoading = false // Good practice for UI feedback
    @Published var errorMessage: String?
    @Published var currentIndex = 0

    
    // FIlter Modal States
    @Published var isBlockingUser: Bool = false
    @Published var selection = 0
    @Published var selectedGender: String = ""
    @Published  var minAge: Double = 18
    @Published  var maxAge: Double = 65
    @Published  var minDistance: Double = 1
    @Published  var maxDistance: Double = 65
    
    var hasFetchedInitialData = false
    
    func getUserProfiles() async throws {
            isLoading = true
        
        do{
            let response: GetProfileResponse = try await NetworkManager.shared.request(endpoint: .getAllProfiles)
            print("response for user profiles:", response)
        
            await MainActor.run{
                self.users = response.data
                self.isLoading = false
                self.hasFetchedInitialData = true
            }
        }catch{
            print("Error at Get user profiles: \(error)")
        }
            
    }
    
    func handleSwipe(direction: SwipeDirection, profile: DiscoverProfile) async {
        print("Swiped \(direction) on profile: \(profile.fullName) (ID: \(profile.id))")
        
        // 1. OPTIMISTIC UPDATE:
        // Update UI immediately so the user can keep swiping without waiting.
        await MainActor.run {
            currentIndex += 1
        }

        // 2. NETWORK REQUEST (Background):
        do {
            if direction == .right {
                print("profile", profile.id)
                let body = sendLike(toUserId: profile.id, action: "Like")
                print("Like:", body)
                let response: likeResponse = try await NetworkManager.shared.request(
                    endpoint: .likeProfile,
                    body: body
                )
                print("Response: ", response)
                print("Like Success: \(String(describing: response.success))")
            } else {
                print("profile", profile.id)
                let body = sendLike(toUserId: profile.id, action: "Dislike")
                let response: likeResponse = try await NetworkManager.shared.request(
                    endpoint: .likeProfile,
                    body: body
                )
                print("Pass Success: \(response.message)")
            }
        } catch {
            print("Failed to sync swipe to backend: \(error.localizedDescription)")
        }
    }
    
    
    func reportProfile(ToUserId: Int, reason: String, comments: String, status: String, images: [UIImage]) async{
        
        let parameters = ["ToUserId": String(ToUserId),
                          "reason": reason,
                          "comments": comments,
                          "status": String(status)
        ]
        
        // call upload function of Network Manager
        do{
            let response: ReportProfileResponse = try await NetworkManager.shared.upload(endpoint: .reportProfile, parameters: parameters, images: images)
            print(response)
        }catch{
            print("Error occured in reporting profile: \(error)")
        }
        
    }
    
    func dislikeProfile(id: Int) async {
        do{
            let response: dislikeResponse = try await NetworkManager.shared.request(endpoint: .dislikeProfile, body: sendDislike(toUserId: String(id)))
            print("Unlike Success: \(String(describing: response.message))")
        }catch{
            print("Error in sending dislike Response: \(error)")
        }
    }
    
//    function messageFunction
    
    func updatePreferences() async {
        // Construct query parameters using URLComponents for safety and readability
        var components = URLComponents()
        var queryItems: [URLQueryItem] = []
        
        if !selectedGender.isEmpty && selectedGender != "All" {
            queryItems.append(URLQueryItem(name: "gender", value: selectedGender))
        }
        
        queryItems.append(URLQueryItem(name: "preferredAge", value: "\(Int(minAge))-\(Int(maxAge))"))
        queryItems.append(URLQueryItem(name: "PreferredRange", value: "\(Int(minDistance))-\(Int(maxDistance))"))
        
        components.queryItems = queryItems
        let query = "?" + (components.percentEncodedQuery ?? "")
        
        print("🔍 DEBUG: Updating preferences with query: \(query)")
        
        await MainActor.run {
            self.isLoading = true
            self.errorMessage = nil
            self.currentIndex = 0 
        }
        
        do {
            let response: PreferenceUpdateResponse = try await NetworkManager.shared.request(endpoint: .search(query: query))
            
            await MainActor.run {
                if let newProfileData = response.data {
                    self.users = newProfileData
                    self.hasFetchedInitialData = true // Prevents onAppear from resetting the list
                    print("✅ Preference update successful: \(response.message). Received \(newProfileData.count) profiles.")
                } else {
                    print("⚠️ No new data to update in response")
                    self.users = []
                }
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.isLoading = false
                self.errorMessage = "Failed to update preferences: \(error.localizedDescription)"
                print("❌ Error in updating preferences: \(error)")
            }
        }
    }
    
} // End

