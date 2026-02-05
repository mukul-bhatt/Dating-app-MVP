//
//  PreferenceUpdateResponse.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 02/02/26.
//


import Foundation

struct PreferenceUpdateResponse : Codable {
    let success: Bool
    let message: String
    let data : [DiscoverProfile]?
    
}
