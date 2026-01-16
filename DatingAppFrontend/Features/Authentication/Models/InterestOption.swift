//
//  InterestOption.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 16/01/26.
//

import Foundation


struct InterestResponse: Codable{
    let success: Bool
    let message: String
    let data: InterestsOptionsHolder
}

struct InterestsOptionsHolder: Codable{
    let interst: [InterestOption]
}

struct InterestOption: Codable, Identifiable, Hashable{
    let id: Int
    let interestsName: String
    let status: String
    let createdAt: String
    let selected: Bool?
    let updatedAt: String
    let deletedAt: Bool?
    
    enum CodingKeys: String, CodingKey{
        case id
        case interestsName
        case status
        case createdAt = "created_At"
        case selected
        case updatedAt = "updated_At"
        case deletedAt = "deleted_At"
        
    }

}
