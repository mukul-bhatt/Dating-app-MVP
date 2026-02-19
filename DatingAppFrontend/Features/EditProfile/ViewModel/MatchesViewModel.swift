//
//  MatchesViewModel.swift
//  DatingAppFrontend
//
//  Created by Antigravity on 19/02/26.
//

import SwiftUI
import Combine

@MainActor
class MatchesViewModel: ObservableObject {
    @Published var matches: [UserMatch] = []
    @Published var isLoadingMatches: Bool = false
    @Published var errorMessage: String? = nil
    
    // MARK: - Fetch Matches
    func fetchMatches() async {
        isLoadingMatches = true
        errorMessage = nil
        
        do {
            let response: UserMatchResponse = try await NetworkManager.shared.request(endpoint: .getMatches)
            
            if response.success {
                self.matches = response.data
                print("✅ Successfully fetched \(response.data.count) matches")
            } else {
                self.errorMessage = "Failed to fetch matches"
                print("❌ Failed to fetch matches: Success flag was false")
            }
        } catch {
            self.errorMessage = "Failed to load matches. Please try again."
            print("❌ Error fetching matches: \(error)")
        }
        
        isLoadingMatches = false
    }
}
