//
//  ProfileData.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 11/01/26.
//

import Foundation

struct UserProfileDTO: Codable {
    let lastName: String
    let user: UserBlock
    let Settings: SettingsBlock
    let Preferences: PreferencesBlock
    let interests: InterestsBlock
}

struct UserBlock: Codable {
    let pronouns: String
    let gender: String
    let dateOfBirth: String
    let sexuality: String
    let bio: String
    let religion: String
    let job: String
    let education: String
    let height: String
    let relationshipStatus: String
    let hope: String
}

struct SettingsBlock: Codable {
    let Location: String
    let PreferredRange: String
    let Latitude: Double
    let Longitude: Double
}

struct PreferencesBlock: Codable {
    let PreferredAge: String
    let PreferredReligion: String
    let PreferredSexuality: String
}

struct InterestsBlock: Codable {
    let InterestsName: String
}



extension ProfileViewModel {
    func printDataSnapshot() {
        // 1. Create the DTO
        let snapshot = UserProfileDTO(
            lastName: "Kapoor", // or from UI later

            user: UserBlock(
                pronouns: pronouns,
                gender: "Male",
                dateOfBirth: "2000-07-05",   // yyyy-MM-dd
                sexuality: sexualityId.map(String.init) ?? "",
                bio: bio,
                religion: selectedReligionId.map(String.init) ?? "",
                job: jobTitle,
                education: education,
                height: height,
                relationshipStatus: relationshipStatus,
                hope: lookingFor
            ),

            Settings: SettingsBlock(
                Location: location,
                PreferredRange: "11km-20km",
                Latitude: 15.67995,
                Longitude: 80.72211
            ),

            Preferences: PreferencesBlock(
                PreferredAge: "18-25",
                PreferredReligion: selectedPartnerReligionsIds.map(String.init).joined(separator: ","),
                PreferredSexuality: selectedPartnerSexualityIds.map(String.init).joined(separator: ","),
            ),

            interests: InterestsBlock(
                InterestsName: "Horse Riding,Tennis"
//                InterestsName: selectedInterests.joined(separator: ",")
            )
        )
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        // 2. Use do-catch to see errors
        do {
            let data = try encoder.encode(snapshot) // Removed '?'
            if let jsonString = String(data: data, encoding: .utf8) {
                print("🚀 BACKEND DATA PREVIEW:")
                print(jsonString)
            }
        } catch {
            print("❌ ENCODING ERROR: \(error.localizedDescription)")
            print("Details: \(error)") // This gives the exact field causing trouble
        }
    }
}
