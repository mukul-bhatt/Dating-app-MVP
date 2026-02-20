//
//  EmailUpdate.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 20/02/26.
//

import Foundation

struct EmailUpdateRequest: Codable {
    let Email: String
}

struct EmailUpdateResponse: Codable{
    let success: Bool
    let message: String
    let profileId: Int?
    let email: String?
    
}
