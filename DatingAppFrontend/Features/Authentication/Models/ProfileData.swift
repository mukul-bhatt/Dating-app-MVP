//
//  ProfileData.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 11/01/26.
//

import Foundation

struct RegisterProfileRequest: Codable {
    let name: String
    let phoneNumber: String
    let countryCode: String
    let gender: String
    let age: Int
    let location: String
    let interests: [String]
}


//extension ProfileViewModel {
//
//    func toRegisterRequest() -> RegisterProfileRequest {
//        return RegisterProfileRequest(
//            name: name,
//            phoneNumber: phone,
//            countryCode: countryCode,
//            gender: gender,
//            age: Int(age) ?? 0,
//            location: location,
//            interests: selectedInterests
//        )
//    }
//}
