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
    // MARK: - States of Register Form
        @Published  var name = ""
        @Published  var phone = ""
        @Published  var selectedGender = ""
        @Published  var dateOfBirth = Date()
    
    // MARK: - Profile Images
        @Published var selectedImages: [UIImage] = []
        @Published var photosPickerItems: [PhotosPickerItem] = []
    
    // MARK: - Basic Details
        @Published var location: String = "New Delhi"
        @Published var hasStartedTypingInLocationField: Bool = false
    
        // Options for Your Pronouns
        @Published var pronounId: Int?
        @Published var pronounOptions: [LookUpOption] = []
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

        // Relationship Status
        @Published var relationshipStatusId: Int? = nil
        @Published var relationshipStatusOptions: [LookUpOption] = []
    
        // Looking for
        @Published var lookingForId: Int? = nil
        @Published var lookingForOptions: [LookUpOption] = []
        
    // MARK: - Selected Interests
        @Published var selectedInterestIds: Set<Int> = []
        @Published var OptionsForInterests: [InterestOption] = []
    
    // MARK: - VALIDATION FOR YOUR HEIGHT
    @Published var errorMessagesForHeight: String?
    
    var isValidHeight: Bool {
        if height.isEmpty {
            errorMessagesForHeight = "This field cannot be empty. Please enter your height in centimetres"
            return false
        }
        
        guard let heightInNumbers = Int(height) else{
            errorMessagesForHeight = "Height must be Whole number"
            return false
        }
        if heightInNumbers >= 140 && heightInNumbers <= 240{
            errorMessagesForHeight = nil
            return true
        }else{
            errorMessagesForHeight = "Height should be greater than 140cm and less than 240 cm"
            return false
        }
        
    }
    
    
    // MARK: - VALIDATION FOR JOB TITLE
    @Published var errorMessageForJobTitleField: String?
    
    func isValidJobTitle() -> Bool {
        if jobTitle.isEmpty {
            errorMessageForJobTitleField = "Job title cannot be empty"
            return false
        }
        
        if jobTitle.count >= 3 && jobTitle.count <= 50 {
            errorMessageForJobTitleField = nil
            return true
        }else{
            errorMessageForJobTitleField = "Job title should be more than 3 characters and less than 50 characters"
            return false
        }
    }
    
    // MARK: - VALIDATION FOR EDUCATION FIELD
    @Published var errorMessageForEducationField: String?
    
    func isValidEducation() -> Bool {
        if education.isEmpty {
            errorMessageForEducationField = "Education cannot be empty"
            return false
        }
        
        if education.count >= 3 && education.count <= 100 {
            errorMessageForEducationField = nil
            return true
        }else{
            errorMessageForEducationField = "Education should be more than 3 characters and less than 100 characters"
            return false
        }
    }
    
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
    
        // MARK: - Validation
        // We will build this logic in the next steps
        var isFormValid: Bool {
            
            
            return !selectedImages.isEmpty &&
                    (!location.isEmpty && isValidLocation) &&
//                    !pronounId.isEmpty &&
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
    let authToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJjZWE0MDYwMS1jZjgwLTQ1MWYtYTJhZS1mODM3MDM3NmU5N2UiLCJqdGkiOiI0MTMwMDM4YS00OGIyLTQwNDctODBhZS1hN2JkMjEwODdiZjIiLCJ1bmlxdWVfbmFtZSI6Ijk5NzEyMTI0ODkiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9tb2JpbGVwaG9uZSI6Ijk5NzEyMTI0ODkiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1laWRlbnRpZmllciI6IjYwMTciLCJwcm9maWxlX2lkIjoiNjAxNyIsImFwcGxpY2F0aW9uX3VzZXJJZCI6ImNlYTQwNjAxLWNmODAtNDUxZi1hMmFlLWY4MzcwMzc2ZTk3ZSIsImV4cCI6MTc2ODU1NDgwNiwiaXNzIjoiRGF0aW5nQXBwIiwiYXVkIjoiYWxsX3VzZXJzIn0.jWvLNv4TUox2Lcyg1DBmjZTTKt2RyfidAjax5flbdsU"

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
    
    func loadOptionsForPronouns() async {
        do {
            let options = try await masterService.fetchOptions(
                endpoint: "/profile/get-master-options/your_pronouns",
                token: authToken
            )
            await MainActor.run {
                self.pronounOptions = options
            }
        } catch {
            print(error)
        }
    }
    
    func loadOptionsForInterests() async {
        let fetchInterest = FetchInterestsService()
        do {
            let interests = try await fetchInterest.fetchOptionsForInterests(
                endpoint: "/profile/get-interests",
                token: authToken
            )
            await MainActor.run {
                self.OptionsForInterests = interests
            }
        } catch {
            print(error)
        }
    }
    
    func uploadImageToServer() async throws {
        
        let boundary = UUID().uuidString
        let baseUrl = masterService.baseUrl
        let endpoint = "/profile/upload-picture"
        guard let url = URL(string: baseUrl+endpoint) else{
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")


        var body = Data()

        for (index, image) in selectedImages.enumerated() {
            guard let data = image.jpegData(compressionQuality: 0.8) else { continue }

            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            let fieldName = index == 0 ? "File" : "File\(index)"
            body.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"photo\(index).jpg\"\r\n".data(using: .utf8)!)

            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(data)
            body.append("\r\n".data(using: .utf8)!)
        }

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body
        
        let (data, response) = try await URLSession.shared.data(for: request)

        if let http = response as? HTTPURLResponse {
                print("📡 STATUS:", http.statusCode)
            }

            print("📦 RESPONSE:", String(data: data, encoding: .utf8) ?? "nil")


    }
 }



