//
//  LocationUpdate.swift
//  DatingAppFrontend
//
//  Created by Antigravity on 03/02/26.
//

import Foundation

struct UpdateLocationRequest: Encodable {
    let Location: String
    let Latitude: String
    let Longitude: String
}

struct UpdateLocationResponse: Decodable {
    let success: Bool?
    let message: String
}
