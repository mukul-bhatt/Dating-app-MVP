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
    @Published var isAuthenticated: Bool = false
    
    private let tokenKey = "authToken"
    private let tokenExpiryKey = "tokenExpiry"
    
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
            // Token is still valid
            self.authToken = token
            self.isAuthenticated = true
        } else {
            // Token has expired
            print("Token expired, logging out")
            logout()
        }
    }
    
    // MARK: - Save token after login/signup
    func saveToken(_ token: String, expiresInHours: Int = 12) {
        self.authToken = token
        self.isAuthenticated = true
        
        // Calculate expiry date (12 hours from now)
        let expiryDate = Calendar.current.date(byAdding: .hour, value: expiresInHours, to: Date())!
        
        // Save to UserDefaults
        UserDefaults.standard.set(token, forKey: tokenKey)
        UserDefaults.standard.set(expiryDate, forKey: tokenExpiryKey)
        
        print("Token saved, expires at: \(expiryDate)")
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
        self.isAuthenticated = false
        UserDefaults.standard.removeObject(forKey: tokenKey)
        UserDefaults.standard.removeObject(forKey: tokenExpiryKey)
    }
}
