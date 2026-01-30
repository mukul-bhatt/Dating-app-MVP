//
//  ReportProfileResponse.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 30/01/26.
//

import Foundation

struct ReportProfileResponse: Codable {
    let success: Bool
    let isReported: Bool
    let message: String
    let reportedTo: Int
}

struct MultipartFile {
    let keyName: String
    let fileName: String
    let data: Data
    let mimeType: String
}
