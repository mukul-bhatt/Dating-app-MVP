//
//  BlockListViewModel.swift
//  DatingAppFrontend
//
//  Created by Antigravity on 24/02/26.
//

import SwiftUI
import Combine

@MainActor
class BlockListViewModel: ObservableObject {
    @Published var blacklistedUsers: [BlacklistedUser] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var isUnblocking: Bool = false
    
    // Alert State
    @Published var showUnblockAlert: Bool = false
    @Published var userToUnblock: BlacklistedUser? = nil
    
    // MARK: - Fetch Blacklisted Users
    func fetchBlacklistedUsers() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response: BlacklistedUserResponse = try await NetworkManager.shared.request(endpoint: .getBlacklistedUsers)
            
            if response.success {
                self.blacklistedUsers = response.data
                print("✅ Successfully fetched \(response.data.count) blacklisted users")
            } else {
                self.errorMessage = response.message
                print("❌ Failed to fetch blacklisted users: \(response.message)")
            }
        } catch {
            self.errorMessage = "Failed to load block list. Please try again."
            print("❌ Error fetching blacklisted users: \(error)")
        }
        
        isLoading = false
    }
    
    // MARK: - Unblock User
    func unblockUser(userId: Int) async -> Bool {
        isUnblocking = true
        errorMessage = nil
        
        let requestBody = UnblockRequest(toUserId: "\(userId)", status: "Unblock")
        
        do {
            let response: GenericResponse = try await NetworkManager.shared.request(
                endpoint: .unblockUser,
                body: requestBody
            )
            
            isUnblocking = false
            if response.success {
                print("✅ Successfully unblocked user: \(userId)")
                // Remove from local list
                self.blacklistedUsers.removeAll { $0.blacklistedUserId == userId }
                return true
            } else {
                self.errorMessage = response.message ?? "Failed to unblock user"
                return false
            }
        } catch {
            isUnblocking = false
            self.errorMessage = "Error unblocking user: \(error.localizedDescription)"
            print("❌ Error unblocking user: \(error)")
            return false
        }
    }
}
