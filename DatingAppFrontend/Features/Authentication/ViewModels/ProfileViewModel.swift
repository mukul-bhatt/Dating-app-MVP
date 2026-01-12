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
    
    // MARK: - Dropdown Selections
        // These are Optional Strings (String?) because they might be nil initially
        @Published var sexuality: String? = nil
        @Published var selectedReligion: String? = nil
        @Published var selectedPartnerReligion: String? = nil
        @Published var partnerSexuality: String? = nil
    
    // MARK: - Work, Education & Intentions
        // These were previously trapped inside WorkEducationView
        @Published var jobTitle: String = ""
        @Published var education: String = ""
        @Published var height: String = ""
        @Published var relationshipStatus: String = ""
        @Published var lookingFor: String = ""
        
    
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
            
//            let hasEnoughImages = selectedImage.count >= 2 && selectedImage.count < 4
            
            
            return !bio.isEmpty &&
            !location.isEmpty &&
            !selectedImage.isEmpty &&
            !pronouns.isEmpty &&
            !lookingFor.isEmpty &&
            !height.isEmpty &&
            !relationshipStatus.isEmpty &&
            !education.isEmpty &&
            hasStartedTypingInLocationField == true
            
            
            
            
            
        }
}

