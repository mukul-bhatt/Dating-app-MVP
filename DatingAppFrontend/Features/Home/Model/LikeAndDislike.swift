//
//  LikeAndDislike.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 27/01/26.
//

import Foundation

struct sendLike: Codable{
//    let toUserId: Int?
//    let action: String?
    let toUserId: Int
    let action: String
}

struct likeResponse: Codable{
//    let success: Bool?
//    let message: String?
//    let status: String?
//    let match: Bool?
    
    let success: Bool
       let message: String
       let status: String
       let match: Bool
}

struct sendPass: Codable{
//    let toUserId: Int?
    let toUserId: String
}

struct passResponse: Codable{
//    let isLikedByMe: Bool?
//    let message: String?
    let isLikedByMe: Bool
       let message: String
}
