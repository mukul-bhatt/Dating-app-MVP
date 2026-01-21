//
//  AuthViewModel.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 20/01/26.
//

import Foundation
import Combine

class AuthViewModel: ObservableObject {
       @Published var authToken: String?
       @Published var refreshToken: String?
       @Published var isAuthenticated: Bool = false
       @Published var profileId: Int?
       @Published var userMobile: String?
    
        private let tokenKey = "authToken"
        private let refreshTokenKey = "refreshToken"
        private let tokenExpiryKey = "tokenExpiry"
        private let profileIdKey = "profileId"
        private let userMobileKey = "userMobile"
    
    init() {
        loadAndValidateToken()
    }
    
    // MARK: - Load and validate token on app launch
    private func loadAndValidateToken() {
        guard let token = UserDefaults.standard.string(forKey: tokenKey),
              let expiryDate = UserDefaults.standard.object(forKey: tokenExpiryKey) as? Date else {
            // No token or expiry date found
            logout()
            return
        }
        
        // Check if token has expired
        if Date() < expiryDate {
                   self.authToken = token
                   self.refreshToken = UserDefaults.standard.string(forKey: refreshTokenKey)
                   self.profileId = UserDefaults.standard.integer(forKey: profileIdKey)
                   self.userMobile = UserDefaults.standard.string(forKey: userMobileKey)
                   self.isAuthenticated = true
                   print("✅ Valid token loaded from storage")
               } else {
                   print("❌ Token expired")
                   logout()
               }
    }
    
    // MARK: - Save token after login/signup
    
    func saveTokenFromResponse(_ response: VerifyOtpResponse, expiresInHours: Int = 12) {
        let tokenData = response.data
        
        self.authToken = tokenData.token
        self.refreshToken = tokenData.refreshToken
        self.profileId = tokenData.profileId
        self.userMobile = tokenData.mobile
        self.isAuthenticated = true
        
        // Calculate expiry date
        let expiryDate = Calendar.current.date(byAdding: .hour, value: expiresInHours, to: Date())!
        
        // Save to UserDefaults
        UserDefaults.standard.set(tokenData.token, forKey: tokenKey)
        UserDefaults.standard.set(tokenData.refreshToken, forKey: refreshTokenKey)
        UserDefaults.standard.set(expiryDate, forKey: tokenExpiryKey)
        UserDefaults.standard.set(tokenData.profileId, forKey: profileIdKey)
        UserDefaults.standard.set(tokenData.mobile, forKey: userMobileKey)
        
        print("✅ Token saved, expires at: \(expiryDate)")
        print("✅ Profile ID: \(tokenData.profileId)")
    }

    
    // MARK: - Check if token is still valid
    func isTokenValid() -> Bool {
        guard let expiryDate = UserDefaults.standard.object(forKey: tokenExpiryKey) as? Date else {
            return false
        }
        return Date() < expiryDate
    }
    
    // MARK: - Get remaining time
    func getRemainingTokenTime() -> TimeInterval? {
        guard let expiryDate = UserDefaults.standard.object(forKey: tokenExpiryKey) as? Date else {
            return nil
        }
        return expiryDate.timeIntervalSince(Date())
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
           UserDefaults.standard.removeObject(forKey: tokenExpiryKey)
           UserDefaults.standard.removeObject(forKey: profileIdKey)
           UserDefaults.standard.removeObject(forKey: userMobileKey)
       }
}

