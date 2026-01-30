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

    
    func getUserProfiles() async throws {
            isLoading = true
        
            let response: GetProfileResponse = try await NetworkManager.shared.request(endpoint: .getAllProfiles)
        
            await MainActor.run{
                self.users = response.data
                self.isLoading = false
            }
    }
    
    func handleSwipe(direction: SwipeDirection, profile: DiscoverProfile) async { // Removed 'throws' to handle errors internally
        print("Swiped \(direction) on profile: \(profile.fullName) (ID: \(profile.id))")
        
        // 1. OPTIMISTIC UPDATE:
        // Update UI immediately so the user can keep swiping without waiting.
        await MainActor.run {
            currentIndex += 1
        }

        // 2. NETWORK REQUEST (Background):
        do {
            if direction == .right {
                let body = sendLike(toUserId: profile.id, action: "Like")
                let response: likeResponse = try await NetworkManager.shared.request(
                    endpoint: .likeProfile,
                    body: body
                )
                print("Like Success: \(String(describing: response.success))")
            } else {
                let body = sendLike(toUserId: profile.id, action: "Reject")
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
    
} // End

