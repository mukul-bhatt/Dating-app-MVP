//
//  ActionButtonsProfile.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 28/01/26.
//

import SwiftUI

struct ActionButtonsProfile: View {
    
//    let id: Int
    var onDislike: (() async -> Void)? = nil
    var onLike: (() async -> Void)? = nil
    var isLiked: Bool = false
    
    
    var body: some View {
        // 7. Action ButtonsImage(systemName: "heart.circle")
        HStack(spacing: 30) {
            Spacer()
            
            // Pass Button
            CircularButton(icon: "HeartSlashIcon", color: AppTheme.foregroundPink, actionToPerform: onDislike)
            
            // Super Like / Message
//            CircularButton(icon: "EnvelopeIcon", color: foregroundPink, size: 80)
            
            // Like Button
            CircularButton(
                icon: isLiked ? "heart.fill" : "heart",
                color: AppTheme.foregroundPink,
                isSystemIcon: true,
                actionToPerform: onLike
            )
            
            Spacer()
        }
        .padding(.vertical, 20)
    }
}

struct CircularButton: View {
    var icon: String
    var color: Color
    var size: CGFloat = 60
    var isSystemIcon: Bool = false
    var actionToPerform: (() async -> Void)? = nil
    var body: some View {
        Button {
            guard let actionToPerform else { return }
            Task {
                await actionToPerform()
            }
        } label: {
            ZStack {
                
                
                Circle()
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                
                if isSystemIcon {
                    Image(systemName: icon)
                        .font(.system(size: size * 0.4))
                        .foregroundColor(color)
                } else {
                    Image(icon)
                        .font(.system(size: size * 0.4))
                        .foregroundColor(color)
                }
                
//                if icon == "EnvelopeIcon" {
//                    Image(systemName: "heart.fill")
//                        .font(.system(size: 18))
//                        .foregroundColor(AppTheme.foregroundPink)
//                        .offset(x: 0, y: 0)
//                }
            }
            .frame(width: size, height: size)
            
        }
    }
    
}
