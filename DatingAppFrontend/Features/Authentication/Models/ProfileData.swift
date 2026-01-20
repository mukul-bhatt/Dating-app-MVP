//
//  ProfileData.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 11/01/26.
//

import Foundation

struct UserProfileDTO: Codable {
    let firstName: String
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
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        // 2. Use do-catch to see errors
        do {
            let data = try encoder.encode(snapshot)
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

extension ProfileViewModel {
    static func formatDOB(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
