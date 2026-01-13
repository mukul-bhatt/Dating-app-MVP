//
//  MasterOptions.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 13/01/26.
//

import Foundation

struct MasterOptionsResponse: Codable{
    let id: Int
    let name: String
    let key: String
    let options: [LookUpOption]
}

struct LookUpOption: Codable, Identifiable, Hashable{
    let id: Int
    let name: String
    let key: String
    let value: String
    let isDefault: Bool
}
