//
//  AuthViewModel.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 20/01/26.
//

import Foundation
import Combine

@MainActor
class AuthViewModel: ObservableObject {
    @Published var authToken: String?
    @Published var refreshToken: String?
    @Published var isAuthenticated: Bool = false
    @Published var profileId: Int?
    @Published var userMobile: String?
    @Published var profilePictureURL: URL?
    
    private let baseUrl = NetworkConfig.baseURL
    private let tokenKey = "authToken"
    private let refreshTokenKey = "refreshToken"
    private let profileIdKey = "profileId"
    private let userMobileKey = "userMobile"
    
    init() {
        Task {
            loadTokensFromStorage()
            
            // 2. ✅ LINK THE MANAGER (Add this line)
            await NetworkManager.shared.setTokenProvider(self)
            ChatSocketManager.shared.setTokenProvider(self)
            print("✅ NetworkManager and ChatSocketManager linked to AuthViewModel")
        }
    }
    
    // MARK: - Load Tokens from Storage
    
    private func loadTokensFromStorage() {
        self.authToken = UserDefaults.standard.string(forKey: tokenKey)
        self.refreshToken = UserDefaults.standard.string(forKey: refreshTokenKey)
        self.profileId = UserDefaults.standard.integer(forKey: profileIdKey)
        self.userMobile = UserDefaults.standard.string(forKey: userMobileKey)
        
        // User is authenticated if both tokens exist
        self.isAuthenticated = authToken != nil && refreshToken != nil
        
        if isAuthenticated {
            print("✅ Tokens loaded from storage")
        } else {
            print("ℹ️ No tokens found - user needs to login")
        }
    }
    
    // MARK: - Refresh token using refresh token ⭐
    // AuthViewModel.swift
    
    func refreshAuthToken() async throws {
        // 1. Ensure both tokens exist before attempting a refresh
        guard let currentToken = self.authToken,
              let currentRefreshToken = self.refreshToken else {
            await MainActor.run { logout() }
            throw AuthNetworkError.unauthorized
        }
        
        let endpoint = "/auth/refresh-token"
        guard let url = URL(string: baseUrl + endpoint) else {
            throw URLError(.badURL)
        }
        
        // 2. Prepare the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 3. Use the RefreshTokenApiBody model for the request body
        let body = RefreshTokenApiBody(token: currentToken, refreshToken: currentRefreshToken)
        request.httpBody = try JSONEncoder().encode(body)
        
        // 4. Perform the network call
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        // 5. Handle the response
        if httpResponse.statusCode == 200 {
            // Decode using your RefreshTokenResponse model
            let refreshResponse = try JSONDecoder().decode(RefreshTokenResponse.self, from: data)
            
            await MainActor.run {
                // Update the source of truth
                self.authToken = refreshResponse.token
                self.refreshToken = refreshResponse.refreshToken
                self.isAuthenticated = true
                
                // Sync with local storage
                UserDefaults.standard.set(refreshResponse.token, forKey: tokenKey)
                UserDefaults.standard.set(refreshResponse.refreshToken, forKey: refreshTokenKey)
                
                print("✅ Token refreshed successfully")
            }
        } else {
            // If refresh fails (e.g., 401 or 403), the refresh token itself is invalid
            print("❌ Token refresh failed with status: \(httpResponse.statusCode)")
            await MainActor.run { logout() }
            throw AuthNetworkError.unauthorized
        }
    }
    
    // MARK: - Save token after OTP verification
    func saveTokenFromResponse(_ response: VerifyOtpResponse) {
        let tokenData = response.data
        
        self.authToken = tokenData.token
        self.refreshToken = tokenData.refreshToken
        self.profileId = tokenData.profileId
        self.userMobile = tokenData.mobile
        print("Is authenticated = true ✅")
        
        // Save to UserDefaults
        UserDefaults.standard.set(tokenData.token, forKey: tokenKey)
        UserDefaults.standard.set(tokenData.refreshToken, forKey: refreshTokenKey)
        UserDefaults.standard.set(tokenData.profileId, forKey: profileIdKey)
        UserDefaults.standard.set(tokenData.mobile, forKey: userMobileKey)
        
        print("✅ Token saved")
    }
    
    // MARK: - Finalize Login
    func finalizeLogin() {
        self.isAuthenticated = true
    }
    
    // MARK: - Logout
    func logout() {
        self.authToken = nil
        self.refreshToken = nil
        self.profileId = nil
        self.userMobile = nil
        self.isAuthenticated = false
        
        UserDefaults.standard.removeObject(forKey: tokenKey)
        UserDefaults.standard.removeObject(forKey: refreshTokenKey)
        UserDefaults.standard.removeObject(forKey: profileIdKey)
        UserDefaults.standard.removeObject(forKey: userMobileKey)
        
        print("🚪 Logged out")
    }
        
        // MARK: - Fetch Current User Profile
        func fetchCurrentUserProfile() async {
            guard isAuthenticated else { return }
            
            do {
                let response: UserProfileDetailResponse = try await NetworkManager.shared.request(endpoint: .getProfileById)
                
                if response.success {
                    let profile = response.data.profile
                    if let url = URL(string: profile.profilePicture) {
                        await MainActor.run {
                            self.profilePictureURL = url
                            print("✅ AuthViewModel: Profile picture updated to: \(profile.profilePicture)")
                        }
                    }
                } else {
                    print("❌ AuthViewModel: Failed to fetch profile: \(response.message)")
                }
            } catch {
                print("❌ AuthViewModel: Error fetching profile: \(error.localizedDescription)")
            }
        }
        

}
