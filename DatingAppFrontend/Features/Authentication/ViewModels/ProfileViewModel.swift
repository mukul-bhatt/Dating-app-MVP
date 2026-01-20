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
    
    // Auth token is needed for the entire app - then why am i storing it here
        @Published var authenticationToken: String = ""
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
    let masterService = MasterOptionsService()
    
    let authToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJjZWE0MDYwMS1jZjgwLTQ1MWYtYTJhZS1mODM3MDM3NmU5N2UiLCJqdGkiOiIwYzk2ZTQ1MC03NzgxLTQ5NzItOTA0ZC1hNDA5ZDViNmM3M2QiLCJ1bmlxdWVfbmFtZSI6Ijk5NzEyMTI0ODkiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9tb2JpbGVwaG9uZSI6Ijk5NzEyMTI0ODkiLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1laWRlbnRpZmllciI6IjYwMTciLCJwcm9maWxlX2lkIjoiNjAxNyIsImFwcGxpY2F0aW9uX3VzZXJJZCI6ImNlYTQwNjAxLWNmODAtNDUxZi1hMmFlLWY4MzcwMzc2ZTk3ZSIsImV4cCI6MTc2ODg4OTczOCwiaXNzIjoiRGF0aW5nQXBwIiwiYXVkIjoiYWxsX3VzZXJzIn0.cK6eMDE_MUigVqDKDa_lVne8bHmxYVWVc5INNCVT3o4"
    
//    let authToken = authenticationToken

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
    
    // MARK: - Call Verify API
    
    func callBackendWithVerifyEndpoint(otp: String) async throws {
        let baseUrl = masterService.baseUrl
        let endpoint = "/auth/verify-otp"
        guard let url = URL(string: baseUrl+endpoint) else{
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let bodyData = OTPVerifyBody(
                Mobile: phoneNumber,
                countryCode: selectedCountryDialCode,
                ProfileId: profileId,
                Otp: otp
            )
        request.httpBody = try JSONEncoder().encode(bodyData)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
            }
        
        print("📦 RESPONSE:", String(data: data, encoding: .utf8) ?? "nil")
        
        // Check if status is NOT 200-299
            if !(200...299).contains(httpResponse.statusCode) {
                // You can even decode the error message from the 'data' here if you want
                throw NSError(domain: "AuthError", code: httpResponse.statusCode)
            }
        
        // Decode response from the server
        let decodedResponse = try JSONDecoder().decode(VerifyOtpResponse.self, from: data)
        
        if decodedResponse.success{
            self.authenticationToken = decodedResponse.data.token
            self.refreshToken = decodedResponse.data.refreshToken
            self.applicationUserId = decodedResponse.data.applicationUserId
            print("✅ authentication token saved:")
        }else {
            print("Error decoding Response")
        }
    }
    
    //  MARK: - Call Register Api

    struct Register: Codable {
        let phoneNumber: String
        let countryCode: String
    }
    
    func callBackendWithRegisterEndpoint() async throws{
        let baseUrl = masterService.baseUrl
        let endpoint = "/auth/register"
        
        guard let url = URL(string: baseUrl+endpoint) else{
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let bodyData = Register(
               phoneNumber: phoneNumber,
               countryCode: selectedCountryDialCode
            )
        
        request.httpBody = try JSONEncoder().encode(bodyData)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
            }
        
        
        print("📦 RESPONSE:", String(data: data, encoding: .utf8) ?? "nil")
        
        // Check if status is NOT 200-299
            if !(200...299).contains(httpResponse.statusCode) {
                // You can even decode the error message from the 'data' here if you want
                throw NSError(domain: "AuthError", code: httpResponse.statusCode)
            }
        
        // Decode response from the server
        let decodedResponse = try JSONDecoder().decode(SendOtpResponse.self, from: data)
        
        if decodedResponse.success{
            self.profileId = decodedResponse.userId
            print("✅ Profile ID saved: \(self.profileId)")
        }else {
            print("Error decoding Response")
        }
        
        
    }

    func postFormDataToBackend() async throws {
        let baseUrl = masterService.baseUrl
        let endpoint = "/profile/set-update-profile"
        
        guard let url = URL(string: baseUrl+endpoint) else{
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
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
        
        request.httpBody = try JSONEncoder().encode(dataToSend)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
            }
        
        
        print("📦 RESPONSE:", String(data: data, encoding: .utf8) ?? "nil")
        
        // Check if status is NOT 200-299
            if !(200...299).contains(httpResponse.statusCode) {
                // You can even decode the error message from the 'data' here if you want
                throw NSError(domain: "AuthError", code: httpResponse.statusCode)
            }
        
        print("✅ Profile Updated Successfully")
    }
    
    
 }





