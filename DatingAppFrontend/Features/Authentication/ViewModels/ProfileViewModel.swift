//
//  ProfileViewModel.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 11/01/26.
//

import SwiftUI
import PhotosUI
import Combine

class ProfileViewModel: ObservableObject{
    
    // MARK: - Profile Images
        @Published var selectedImage: [UIImage] = []
        @Published var photosPickerItems: [PhotosPickerItem] = []
    
    // MARK: - Basic Details
        @Published var location: String = "New Delhi"
        @Published var hasStartedTypingInLocationField: Bool = false
        @Published var pronouns: String = ""
        @Published var bio: String = ""
    
    // MARK: - Dropdown Selections for Religion
 
        @Published var religionOptions: [LookUpOption] = []
        @Published var selectedReligion: String? = nil
        @Published var selectedReligionId: Int? = nil
        @Published var selectedPartnerReligions: Set<String> = []
        @Published var selectedPartnerReligionsIds: Set<Int> = []
    
        
    // MARK: - Dropdown Selections for Sexuality
    // These are Optional Strings (String?) because they might be nil initially
        @Published var sexuality: String? = nil
        @Published var partnerSexuality: String? = nil
        @Published var selectedPartnerSexuality: Set<String> = []
        @Published var sexualityId: Int? = nil
        @Published var selectedPartnerSexualityIds: Set<Int> = []
        @Published var sexualityOptions : [LookUpOption] = []
    

    // MARK: - Work, Education & Intentions
        // These were previously trapped inside WorkEducationView
        @Published var jobTitle: String = ""
        @Published var education: String = ""
        @Published var height: String = ""
//        @Published var relationshipStatus: String = ""
        @Published var relationshipStatusId: Int? = nil
        @Published var relationshipStatusOptions: [LookUpOption] = []
    
        @Published var lookingForId: Int? = nil
        @Published var lookingForOptions: [LookUpOption] = []
        
    
    // MARK: - Validation for Your Location
    
    var isValidLocation: Bool {
           let trimmed = location.trimmingCharacters(in: .whitespaces)
           return !trimmed.isEmpty &&
                  trimmed.count >= 3 &&
                  trimmed.count <= 50 &&
                  !trimmed.contains(where: { $0.isNumber }) &&
                  trimmed.contains(where: { $0.isLetter })
       }
    
    // Helper to provide specific error message
    var validationMessageForLocation: String {
            let trimmed = location.trimmingCharacters(in: .whitespaces)
            
            if trimmed.isEmpty {
                return "Location cannot be empty"
            } else if trimmed.count < 3 {
                return "Location must be at least 3 characters"
            } else if !trimmed.contains(where: { $0.isLetter }) {
                return "Location must contain letters"
            } else {
                return "Please enter a valid location"
            }
        }
    
    
    // MARK: - Validation for Your Pronouns
    var isValidPronouns: Bool {
        !pronouns.isEmpty && !pronouns.contains(where: { $0.isNumber })
    }
    
    
    
    
        // MARK: - Validation
        // We will build this logic in the next steps
        var isFormValid: Bool {
            
            
            return !selectedImage.isEmpty &&
                    (!location.isEmpty && isValidLocation) &&
                    !pronouns.isEmpty &&
                    !bio.isEmpty &&
                    !jobTitle.isEmpty &&
                    !education.isEmpty &&
                    !height.isEmpty &&
//                    !lookingFor.isEmpty &&
//                    !relationshipStatus.isEmpty &&
                    !height.isEmpty
        }

    // MARK: - Master options functions
    let masterService = MasterOptionsService()
    let authToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJjZWE0MDYwMS1jZjgwLTQ1MWYtYTJhZS1mODM3MDM3NmU5N2UiLCJqdGkiOiIwZmMyMWI0Yy03MmM3LTQ2MGQtYTkwNS1kODRjYjUwYzlmODkiLCJ1bmlxdWVfbmFtZSI6Ijk5NzEyMTI0ODkiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9tb2JpbGVwaG9uZSI6Ijk5NzEyMTI0ODkiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1laWRlbnRpZmllciI6IjYwMTciLCJwcm9maWxlX2lkIjoiNjAxNyIsImFwcGxpY2F0aW9uX3VzZXJJZCI6ImNlYTQwNjAxLWNmODAtNDUxZi1hMmFlLWY4MzcwMzc2ZTk3ZSIsImV4cCI6MTc2ODQ2MzQ4NywiaXNzIjoiRGF0aW5nQXBwIiwiYXVkIjoiYWxsX3VzZXJzIn0.E5LsX04XCV2O823TdobdpkySptd0z71JYX-FnK3ofM0"

    func loadReligionOptions() async {
        do {
            let options = try await masterService.fetchOptions(
                endpoint: "/profile/get-master-options/partner_religion",
                token: authToken
            )
            await MainActor.run {
                self.religionOptions = options
            }
        } catch {
            print(error)
        }
    }
    
    func loadSexualityOptions() async {
        do {
            let options = try await masterService.fetchOptions(
                endpoint: "/profile/get-master-options/partner_sexuality",
                token: authToken
            )
            await MainActor.run {
                self.sexualityOptions = options
            }
        } catch {
            print(error)
        }
    }
    
    func loadRelationshipStatusOptions() async {
        do {
            let options = try await masterService.fetchOptions(
                endpoint: "/profile/get-master-options/relationship_status",
                token: authToken
            )
            await MainActor.run {
                self.relationshipStatusOptions = options
            }
        } catch {
            print(error)
        }
    }
    
    func loadLookingForOptions() async {
        do {
            let options = try await masterService.fetchOptions(
                endpoint: "/profile/get-master-options/what_are_you_hoping_to_find_here",
                token: authToken
            )
            await MainActor.run {
                self.lookingForOptions = options
            }
        } catch {
            print(error)
        }
    }
}





//let apiUrl = "https://datolitic-unprejudiced-lawson.ngrok-free.dev/api"


// func fetchMasterOptionsForReligion() async {
//        guard let url = URL(string: apiUrl + "/profile/get-master-options/partner_religion") else { return }
//
//        // 1. Create a Request object
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//
//        // 2. Add the Authorization Header
//        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
//
//        // Optional: It's good practice to tell the server you want JSON
//        request.setValue("application/json", forHTTPHeaderField: "Accept")
//
//        do {
//            // 3. Use .data(for: request) instead of .data(from: url)
//            let (data, response) = try await URLSession.shared.data(for: request)
//
//            // 🔍 DEBUG: Check if the token worked (Expect status code 200)
//            if let httpResponse = response as? HTTPURLResponse {
//                print("📡 STATUS CODE: \(httpResponse.statusCode)") // Should be 200
//            }
//
//            // 🔍 DEBUG: Print the raw JSON to see if we got data or an error
//            if let jsonString = String(data: data, encoding: .utf8) {
//                print("🚀 RAW RESPONSE: \(jsonString)")
//            }
//
//            // 4. Decode
//            let decodedResponse = try JSONDecoder().decode(MasterOptionsResponse.self, from: data)
//
//            DispatchQueue.main.async {
//                self.religionOptions = decodedResponse.options
//            }
//
//        } catch {
//            print("❌ FETCH ERROR: \(error)")
//        }
//    }



//    func fetchMastersOptionsForSexuality() async {
//        guard let url = URL(string: apiUrl + "/profile/get-master-options/partner_sexuality") else { return }
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//
//        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
//
//        // Optional: It's good practice to tell the server you want JSON
//        request.setValue("application/json", forHTTPHeaderField: "Accept")
//
//        do{
//            let (data, response) = try await URLSession.shared.data(for: request)
//
//            // 🔍 DEBUG: Check if the token worked (Expect status code 200)
//            if let httpResponse = response as? HTTPURLResponse {
//                print("📡 STATUS CODE: \(httpResponse.statusCode)") // Should be 200
//            }
//
//            // 🔍 DEBUG: Print the raw JSON to see if we got data or an error
//            if let jsonString = String(data: data, encoding: .utf8) {
//                print("🚀 RAW RESPONSE: \(jsonString)")
//            }
//
//            // 4. Decode
//            let decodedResponse = try JSONDecoder().decode(MasterOptionsResponse.self, from: data)
//
//            DispatchQueue.main.async {
//                self.sexualityOptions = decodedResponse.options
//            }
//        }catch {
//            print("❌ FETCH ERROR: \(error)")
//        }
//    }
//
