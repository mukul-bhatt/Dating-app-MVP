//
//  DiscoverViewModel.swift
//  DatingAppFrontend
//
//  Created by Antigravity on 16/01/25.
//

import Foundation
import Combine
import PhotosUI
import CoreLocation
import UIKit

enum SwipeDirection {
    case left
    case right
}

class DiscoverViewModel: ObservableObject {
    @Published var users: [DiscoverProfile] = []
    @Published var isLoading = false 
    @Published var errorMessage: String?
    @Published var currentIndex = 0
    @Published var isReporting = false

    
    // Filter Modal States
    @Published var isBlockingUser: Bool = false
    @Published var selection = 0
    @Published var selectedGender: String = "All"
    @Published var minAge: Double = 18
    @Published var maxAge: Double = 65
    @Published var minDistance: Double = 0
    @Published var maxDistance: Double = 500
    
    // Location state
    @Published var latitude: Double?
    @Published var longitude: Double?
    @Published var cityName: String?
    private var cancellables = Set<AnyCancellable>()
    
    var hasFetchedInitialData = false
    /// Set to true only after the backend confirms it has received the user's real location.
    /// getUserProfiles() waits on this before fetching, preventing a race condition.
    private var isLocationSynced = false
    
    init() {
        setupLocationTracking()
    }
    
    private func setupLocationTracking() {
        LocationManager.shared.$location
            .compactMap { $0 }
            .sink { [weak self] location in
                self?.latitude = location.coordinate.latitude
                self?.longitude = location.coordinate.longitude
                self?.syncLocationWithBackend()
            }
            .store(in: &cancellables)
        
        LocationManager.shared.$cityName
            .sink { [weak self] city in
                self?.cityName = city
                self?.syncLocationWithBackend()
            }
            .store(in: &cancellables)
    }
    
    private func syncLocationWithBackend() {
        guard let lat = latitude, let long = longitude, let city = cityName else { return }
        
        Task {
            let request = UpdateLocationRequest(
                Location: city,
                Latitude: "\(lat)",
                Longitude: "\(long)"
            )
            
            do {
                let response: UpdateLocationResponse = try await NetworkManager.shared.request(
                    endpoint: .updateLocation,
                    body: request
                )
                print("✅ Backend Location Sync Success: \(response.message)")
                self.isLocationSynced = true
            } catch {
                print("❌ Backend Location Sync Failed: \(error.localizedDescription)")
                // Still mark as synced so getUserProfiles() doesn't wait forever
                self.isLocationSynced = true
            }
        }
    }
    
    func getUserProfiles() async throws {
        await MainActor.run {
            isLoading = true
        }
        
        // Request location — the delegate callback will fire syncLocationWithBackend()
        // which sets isLocationSynced = true once the backend confirms receipt.
        LocationManager.shared.requestLocation()
        
        // Wait for the backend to receive the real location before fetching profiles.
        // This prevents the race condition where profiles are fetched before the
        // backend knows where the user is (which causes an empty response).
        // Timeout after 8 seconds so the app doesn't hang if location is unavailable.
        let timeoutMs = 80 // 80 × 100ms = 8 seconds
        var waited = 0
        while !isLocationSynced && waited < timeoutMs {
            try await Task.sleep(nanoseconds: 100_000_000) // 0.1s
            waited += 1
        }
        
        if waited >= timeoutMs {
            print("⚠️ Location sync timed out — fetching profiles anyway")
        } else {
            print("✅ Location synced after \(waited * 100)ms — fetching profiles")
        }
        
        do {
            let response: GetProfileResponse = try await NetworkManager.shared.request(endpoint: .getAllProfiles)
            
            print("response for user profiles:", response)
            print("Profiles fetched successfully")
            await MainActor.run {
                self.users = response.data
                self.isLoading = false
                self.hasFetchedInitialData = true
            }
        } catch {
            print("Error at Get user profiles: \(error)")
            await MainActor.run {
                self.isLoading = false
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func handleSwipe(direction: SwipeDirection, profile: DiscoverProfile) async {
        print("Swiped \(direction) on profile: \(profile.fullName) (ID: \(profile.id))")
        
        await MainActor.run {
            currentIndex += 1
        }

        do {
            if direction == .right {
                let body = sendLike(toUserId: profile.id, action: "Like")
                let response: likeResponse = try await NetworkManager.shared.request(
                    endpoint: .likeProfile,
                    body: body
                )
                print("Like Success: \(String(describing: response.success))")
            } else {
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
    
    
    func reportProfile(ToUserId: Int, reason: String, comments: String, status: String, images: [UIImage]) async -> Bool {
        await MainActor.run {
            isReporting = true
        }
        
        defer {
            Task {
                await MainActor.run {
                    isReporting = false
                }
            }
        }
        
        let parameters = ["ToUserId": String(ToUserId),
                          "reason": reason,
                          "comments": comments,
                          "status": String(status)
        ]
        
        do {
            let response: ReportProfileResponse = try await NetworkManager.shared.upload(endpoint: .reportProfile, parameters: parameters, images: images)
            print("✅ Report Success: \(response)")
            return true
        } catch {
            print("❌ Error occured in reporting profile: \(error)")
            return false
        }
    }
    
    func dislikeProfile(id: Int) async {
        do {
            let response: dislikeResponse = try await NetworkManager.shared.request(endpoint: .dislikeProfile, body: sendDislike(toUserId: String(id)))
            print("Unlike Success: \(String(describing: response.message))")
        } catch {
            print("Error in sending dislike Response: \(error)")
        }
    }

    func likeProfile(id: Int) async {
        do {
            let body = sendLike(toUserId: id, action: "Like")
            let response: likeResponse = try await NetworkManager.shared.request(
                endpoint: .likeProfile,
                body: body
            )
            print("Like Success: \(response.message)")
        } catch {
            print("Error in sending like Response: \(error)")
        }
    }
    
    func updatePreferences() async {
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
            let response: GetProfileResponse = try await NetworkManager.shared.request(endpoint: .search(query: query))
//            let response: GetProfileResponse = try await NetworkManager.shared.request(endpoint: .getAllProfiles)
            await MainActor.run {
                self.users = response.data
                self.hasFetchedInitialData = true
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
}

