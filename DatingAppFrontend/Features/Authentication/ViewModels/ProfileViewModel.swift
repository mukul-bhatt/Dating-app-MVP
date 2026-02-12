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
    @Published var hasAttemptedSubmit: Bool = false
    
    
    @Published var refreshToken: String = ""
    @Published var applicationUserId: String = ""
    // MARK: - States of Register Form
    @Published  var name = ""
    @Published  var phoneNumber: String = ""
    @Published  var selectedGender = ""
    @Published  var dateOfBirth = Date()
    @Published  var hasSelectedDate = false
    @Published  var selectedCountryDialCode: String = "91"
    @Published  var profileId: Int = 1009
    
    // MARK: - Profile Images
    @Published var selectedImages: [UIImage] = []
    @Published var photosPickerItems: [PhotosPickerItem] = []
    @Published var profileImageURLs: [String] = []
    
    // MARK: - Basic Details
    @Published var location: String = ""
    @Published var hasStartedTypingInLocationField: Bool = false
    
    // Options for Your Pronouns
    @Published var pronounId: Int?
    @Published var pronounOptions: [LookUpOption] = []
    
    // Bio
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
    
    // MARK: - Range values
    @Published var minValue: Double = 3
    @Published var maxValue: Double = 60
    @Published var minValueForAge: Double = 18
    @Published var maxValueForAge: Double = 60
    
    // MARK: - VALIDATION FOR REGISTER FORM
    
    var isRegisterFormValid: Bool {
        return !name.isEmpty &&
        !phoneNumber.isEmpty &&
        !selectedGender.isEmpty &&
        hasSelectedDate == true
    }
    
    // MARK: - VALIDATION FOR YOUR HEIGHT
    // 1. A property just for the Boolean check
    var isValidHeight: Bool {
        guard let heightInNumbers = Int(height) else { return false }
        return heightInNumbers >= 140 && heightInNumbers <= 240
    }
    
    // 2. A separate property that CALCULATES the message on the fly
    var heightValidationMessage: String? {
        if height.isEmpty {
            return "This field cannot be empty. Please enter your height in centimetres"
        }
        
        guard let heightInNumbers = Int(height) else {
            return "Height must be Whole number"
        }
        
        if heightInNumbers < 140 || heightInNumbers > 240 {
            return "Height should be greater than 140cm and less than 240 cm"
        }
        
        return nil // No error
    }
    
    
    // MARK: - VALIDATION FOR JOB TITLE
    
    var isValidJobTitle: Bool{
        return !jobTitle.isEmpty && (jobTitle.count >= 3 && jobTitle.count <= 50)
    }
    
    var errorMessageForJobTitleField: String?{
        
        if jobTitle.isEmpty {
            return "Job title cannot be empty"
        }
        
        if jobTitle.count < 3 || jobTitle.count > 50 {
            return "Job title should be more than 3 characters and less than 50 characters"
        }
        
        return nil
    }
    
    // MARK: - VALIDATION FOR EDUCATION FIELD
    
    var isValidEducation: Bool {
        return !education.isEmpty && (education.count >= 3 && education.count <= 100)
    }
    
    var errorMessageForEducationField: String? {
        if education.isEmpty {
            return "Education cannot be empty"
        }
        
        if education.count < 3 || education.count > 100 {
            return "Education should be more than 3 characters and less than 100 characters"
        }
        return nil
    }
    
    // MARK: - Validation for Your Location
    
    var isValidLocation: Bool {
        let trimmed = location.trimmingCharacters(in: .whitespaces)
        
        return  !trimmed.isEmpty &&
        (trimmed.count >= 3 || trimmed.count <= 50) &&
        !trimmed.contains(where: { $0.isNumber }) &&
        trimmed.contains(where: { $0.isLetter })
        
    }
    
    var errorMessageForLocation: String?{
        let trimmed = location.trimmingCharacters(in: .whitespaces)
        if trimmed.isEmpty {
            return "Location cannot be empty"
        }
        if trimmed.count < 3 || trimmed.count > 50{
            return "Location must be at least 3 characters and less than or equal to 50 characters"
        }
        if trimmed.contains(where: { $0.isNumber }){
            return "Location cannot contain numbers"
        }
        if !trimmed.contains(where: { $0.isLetter }){
            return "Location must contain letters"
        }
        return nil
    }
    
    // MARK: - Validation for Current RelationshipStatus
    
    var isRelationshipStatusValid: Bool {
        return relationshipStatusId != nil
    }
    
    var errorMessageForRelationshipStatus: String? {
        if relationshipStatusId == nil {
            return "Please select your current relationship status"
        }
        return nil
    }
    
    // MARK: - Validation for What are you hoping to find here
    
    var isLookingForFieldValid: Bool {
        return lookingForId != nil
    }
    
    var errorMessageForLookingForField: String? {
        if lookingForId == nil {
            return "Please select one of the above options"
        }
        return nil
    }
    // MARK: - Validation for What are you hoping to find here
    
    var isPronounValid: Bool {
        return pronounId != nil
    }
    
    var errorMessageForPronounField: String? {
        if pronounId == nil {
            return "Please select one of the above options"
        }
        return nil
    }
    
    // MARK: - Validation for BIO Section
    var isBioValid: Bool {
        return !bio.isEmpty
    }
    
    var errorMessageForBioField: String? {
        if bio.isEmpty {
            return "Bio cannot be empty"
        }
        return nil
    }
    
    // MARK: - Validation for Image Selection
    @Published var errorMessageForImageSelection: String?
    
    var isImageSelectionValid: Bool{
        if !selectedImages.isEmpty{
            errorMessageForImageSelection = nil
            return true
        }else{
            errorMessageForImageSelection = "You must select at least one image"
            return false
        }
        
    }
    // MARK: - Validation for Selected Religion
    
    // A property that only checks the logic
    var isSelectedReligionValid: Bool {
        selectedReligionId != nil
    }
    
    // A property that only returns the message
    var errorMessageForSelectedReligionField: String? {
        if selectedReligionId == nil {
            return "You must select your Religion"
        }
        return nil
    }
    
    var isPreferredPartnerReligionValid: Bool{
        !selectedPartnerReligionsIds.isEmpty
    }
    
    var errorMessageForPreferredPartnerReligionField: String? {
        if selectedPartnerReligionsIds.isEmpty{
            return "Please select Preferences for Partner's Religion"
        }else{
            return nil
        }
    }
    
    // MARK: - Validation for Selected Sexuality
    
    var isSelectedSexualityValid: Bool {
        sexualityId != nil
    }
    
    var errorMessageForSelectedSexualityField: String? {
        if sexualityId == nil{
            return "You must select your Sexuality"
        }else{
            return nil
        }
    }
    
    var isPreferredPartnerSexualityValid: Bool{
        !selectedPartnerSexualityIds.isEmpty
    }
    
    var errorMessageForPreferredPartnerSexualityField: String? {
        if selectedPartnerSexualityIds.isEmpty{
            return "Please select Preferences for Partner's Sexuality"
        }else{
            return nil
        }
    }
    
    // MARK: - VALIDATIONS FOR SELECTED INTERESTS
    var isInterestSelectionValid: Bool{
        !selectedInterestIds.isEmpty && selectedInterestIds.count == 5
    }
    
    var errorMessageForInterestSelectionScreen: String? {
        if selectedInterestIds.isEmpty{
            return "Please select some interests"
        }else if selectedInterestIds.count < 5{
            return "Please select 5 interests to continue"
        }else{
            return nil
        }
        
    }
    
    // MARK: - Profile Form Validation
    // We will build this logic in the next steps
    var isFormValid: Bool {
        
        return isPronounValid &&
        isBioValid &&
        isSelectedReligionValid  &&
        isPreferredPartnerReligionValid &&
        isSelectedSexualityValid &&
        isPreferredPartnerSexualityValid &&
        isValidHeight &&
        isValidJobTitle &&
        isValidEducation &&
        isValidLocation &&
        isRelationshipStatusValid &&
        isLookingForFieldValid
    }
    
    // MARK: - Master options functions
    
    func loadReligionOptions() async {
        do {
            let response: MasterOptionsResponse = try await NetworkManager.shared.request(endpoint: .getMasterOptions(type: "partner_religion"))
            await MainActor.run {
                self.religionOptions = response.options
            }
        } catch {
            print("❌ Error loading religion options: \(error)")
        }
    }
    
    func loadSexualityOptions() async {
        do {
            let response: MasterOptionsResponse = try await NetworkManager.shared.request(endpoint: .getMasterOptions(type: "partner_sexuality"))
            await MainActor.run {
                self.sexualityOptions = response.options
            }
        } catch {
            print("❌ Error loading sexuality options: \(error)")
        }
    }
    
    func loadRelationshipOptions() async {
        do {
            let response: MasterOptionsResponse = try await NetworkManager.shared.request(endpoint: .getMasterOptions(type: "relationship_status"))
            await MainActor.run {
                self.relationshipStatusOptions = response.options
            }
        } catch {
            print("❌ Error loading relationship options: \(error)")
        }
    }
    
    func loadLookingForOptions() async {
        do {
            let response: MasterOptionsResponse = try await NetworkManager.shared.request(endpoint: .getMasterOptions(type: "what_are_you_hoping_to_find_here"))
            await MainActor.run {
                self.lookingForOptions = response.options
            }
        } catch {
            print("❌ Error loading looking for options: \(error)")
        }
    }
    
    func loadOptionsForPronouns() async {
        do {
            let response: MasterOptionsResponse = try await NetworkManager.shared.request(endpoint: .getMasterOptions(type: "your_pronouns"))
            await MainActor.run {
                self.pronounOptions = response.options
            }
        } catch {
            print("❌ Error loading pronoun options: \(error)")
        }
    }
    
    func loadOptionsForInterests() async {
        do {
            let response: InterestResponse = try await NetworkManager.shared.request(endpoint: .getInterests)
            await MainActor.run {
                self.OptionsForInterests = response.data.interst
            }
        } catch {
            print("❌ Error loading interests: \(error)")
        }
    }
    
    func uploadImages() async throws {
        // Use the centralized NetworkManager's upload method
        let _: EmptyResponse = try await NetworkManager.shared.upload(
            endpoint: .uploadPicture,
            images: selectedImages,
            imageFieldName: "File",
            useIndexedFieldNames: true
        )
        print("✅ Images uploaded successfully")
    }
    
    @MainActor
    func loadSelectedImages() async {
        selectedImages.removeAll()
        for item in photosPickerItems {
            if let data = try? await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                selectedImages.append(image)
            }
        }
    }
    
    // MARK: - Load Profile Data for Pre-filling
    @MainActor
    func loadProfileData() async {
        do {
            let response: UserProfileDetailResponse = try await NetworkManager.shared.request(endpoint: .getProfileById)
            
            guard response.success else {
                print("❌ Failed to fetch profile: \(response.message)")
                return
            }
            
            let profile = response.data.profile
            
            // Basic Info
            self.name = profile.firstName
            self.selectedGender = profile.gender
            self.location = profile.location
            self.bio = profile.bio
            self.jobTitle = profile.job
            self.education = profile.education
            self.height = profile.height
            
            // Date of Birth
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let dob = dateFormatter.date(from: profile.dateOfBirth) {
                self.dateOfBirth = dob
                self.hasSelectedDate = true
            }
            
            // IDs from lookup values
            self.pronounId = profile.pronouns?.id
            self.sexualityId = profile.sexuality?.id
            self.selectedReligionId = profile.religion?.id
            self.relationshipStatusId = profile.relationshipStatus?.id
            self.lookingForId = profile.hope?.id
            
            // Partner Preferences
            self.selectedPartnerReligionsIds = Set(profile.preferredReligion.map { $0.id })
            self.selectedPartnerSexualityIds = Set(profile.preferredSexuality.map { $0.id })
            
            // Parse ranges
            if let ageRange = parseRange(profile.preferredAge) {
                self.minValueForAge = ageRange.min
                self.maxValueForAge = ageRange.max
            }
            
            if let distanceRange = parseRange(profile.preferredRange) {
                self.minValue = distanceRange.min
                self.maxValue = distanceRange.max
            }
            
            // Interests - map interest names to IDs
            if !profile.interests.isEmpty {
                // Load interests options if not already loaded
                if self.OptionsForInterests.isEmpty {
                    await loadOptionsForInterests()
                }
                
                // Match interest names to IDs
                let interestIds = self.OptionsForInterests
                    .filter { option in profile.interests.contains(option.interestsName) }
                    .map { $0.id }
                self.selectedInterestIds = Set(interestIds)
            }
            
            // Store profile image URLs
            self.profileImageURLs = profile.imageProfiles
            
            print("✅ Profile data loaded successfully")
            
        } catch {
            print("❌ Error loading profile data: \(error)")
        }
    }
    
    // Helper function to parse range strings like "18-60"
    private func parseRange(_ rangeString: String) -> (min: Double, max: Double)? {
        let components = rangeString.split(separator: "-")
        guard components.count == 2,
              let min = Double(components[0]),
              let max = Double(components[1]) else {
            return nil
        }
        return (min, max)
    }
    
    // MARK: - Call Verify API
    // Inside ProfileViewModel.swift
    
    func callBackendWithVerifyEndpoint(otp: String) async throws -> VerifyOtpResponse {
        // 1. Prepare the body data using your existing model
        let bodyData = OTPVerifyBody(
            Mobile: phoneNumber,
            countryCode: selectedCountryDialCode,
            ProfileId: profileId,
            Otp: otp
        )
        
        return try await NetworkManager.shared.request(
            endpoint: .verifyOtp,
            body: bodyData
        )
    }
    //  MARK: - Verify Otp AND Navigate
    //    func verifyLoginOtpAndNavigate() {
    //        Task {
    //            do {
    //                // The NetworkManager will try the call, and if it hits a 401,
    //                // it will refresh the token and retry BEFORE returning the response here.
    //                let response = try await callBackendWithVerifyEndpoint(otp: combinedOtp)
    //                
    //                if response.success {
    //                    // If user is not a user, only then you navigate, otherwise take them to Register screen.
    //                    await MainActor.run {
    //                        authViewModel.saveTokenFromResponse(response)
    //                        navigateToDiscoverScreen = true
    //                    }
    //                    
    //                    
    //                }
    //            } catch {
    //                // If it lands here, it means either the internet is out
    //                // or even the Refresh Token was expired.
    //                await MainActor.run {
    //                    showInvalidOtpError = true
    //                }
    //                print("❌ Final failure after retries: \(error)")
    //            }
    //        }
    //    }
    //  MARK: - Call Register Api
    
    func callBackendWithRegisterEndpoint() async throws -> SendOtpResponse {
        let bodyData = Register(
            phoneNumber: phoneNumber,
            countryCode: selectedCountryDialCode
        )
        
        let response: SendOtpResponse = try await NetworkManager.shared.request(
            endpoint: .register,
            body: bodyData
        )
        
        if response.success {
            await MainActor.run {
                self.profileId = response.userId
            }
            print("✅ Profile ID saved: \(response.userId)")
        } else {
            print("❌ Error in registration response")
        }
        
        return response
    }
    
    func postFormDataToBackend() async throws {
        let dataToSend = UserProfileDTO(
            firstName: name,
            lastName: "",
            
            user: UserBlock(
                pronouns: pronounId.map(String.init) ?? "",
                gender: selectedGender,
                dateOfBirth: Self.formatDOB(dateOfBirth),   // yyyy-MM-dd
                sexuality: sexualityId.map(String.init) ?? "",
                bio: bio,
                religion: selectedReligionId.map(String.init) ?? "",
                job: jobTitle,
                education: education,
                height: height,
                relationshipStatus: relationshipStatusId.map(String.init) ?? "",
                hope: lookingForId.map(String.init) ?? ""
            ),
            
            Settings: SettingsBlock(
                Location: location,
                PreferredRange: "\(Int(minValue))-\(Int(maxValue))",
                Latitude: 15.67995,
                Longitude: 80.72211
            ),
            
            Preferences: PreferencesBlock(
                PreferredAge: "\(Int(minValueForAge))-\(Int(maxValueForAge))",
                PreferredReligion: selectedPartnerReligionsIds.map(String.init).joined(separator: ","),
                PreferredSexuality: selectedPartnerSexualityIds.map(String.init).joined(separator: ","),
            ),
            
            interests: InterestsBlock(
                InterestsName: selectedInterestIds.map(String.init).joined(separator: ",")
            )
        )
        
        let _: EmptyResponse = try await NetworkManager.shared.request(
            endpoint: .updateProfile,
            body: dataToSend
        )
        
        print("✅ Profile Updated Successfully")
    }
    
    
    
    
}


