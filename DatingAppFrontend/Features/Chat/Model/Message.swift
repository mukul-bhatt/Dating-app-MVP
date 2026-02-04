//
//  Message.swift
//  DatingAppFrontend
//
//  Created by Antigravity on 04/02/26.
//

import Foundation

struct Message: Identifiable {
    let id = UUID()
    let text: String
    let isFromMe: Bool
}
