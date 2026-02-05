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
    @Published var selectedGender: String = ""
    @Published var minAge: Double = 18
    @Published var maxAge: Double = 65
    @Published var minDistance: Double = 1
    @Published var maxDistance: Double = 65
    
    // Location state
    @Published var latitude: Double?
    @Published var longitude: Double?
    @Published var cityName: String?
    private var cancellables = Set<AnyCancellable>()
    
    var hasFetchedInitialData = false
    
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
            } catch {
                print("❌ Backend Location Sync Failed: \(error.localizedDescription)")
            }
        }
    }
    
    func getUserProfiles() async throws {
        await MainActor.run {
            isLoading = true
        }
        
        // Request location before fetching profiles
        LocationManager.shared.requestLocation()
        
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
            let response: PreferenceUpdateResponse = try await NetworkManager.shared.request(endpoint: .search(query: query))
            
            await MainActor.run {
                if let newProfileData = response.data {
                    self.users = newProfileData
                    self.hasFetchedInitialData = true 
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
}
