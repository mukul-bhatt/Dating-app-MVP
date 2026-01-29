//
//  DiscoverViewModel.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 27/01/26.
//

import Foundation
import Combine

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
                let body = sendPass(toUserId: String(profile.id)) // Ensure this struct accepts Int if profile.id is Int
                let response: passResponse = try await NetworkManager.shared.request(
                    endpoint: .dislikeProfile,
                    body: body
                )
                print("Pass Success: \(response.message)")
            }
        } catch {
            // 3. SILENT FAILURE HANDLER:
            // If it fails, just log it. Do NOT throw, or you break the UI flow.
            // Optionally: You could save this to a "retry queue" for later.
            print("Failed to sync swipe to backend: \(error.localizedDescription)")
        }
    }
    
    
} // End

