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
    var onMessage: (() async -> Void)? = nil
    
    
    var body: some View {
        // 7. Action Buttons
        HStack(spacing: 30) {
            Spacer()
            
            // Pass Button
            CircularButton(icon: "HeartSlashIcon", color: AppTheme.foregroundPink, actionToPerform: onDislike)
            
            // Super Like / Message
//            CircularButton(icon: "EnvelopeIcon", color: foregroundPink, size: 80)
            
//             Chat Button
            CircularButton(icon: "MessageIcon", color: AppTheme.foregroundPink, actionToPerform: onMessage)
            
            Spacer()
        }
        .padding(.vertical, 20)
    }
}

struct CircularButton: View {
    var icon: String
    var color: Color
    var size: CGFloat = 60
//    let id: Int
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
                
                Image(icon)
                    .font(.system(size: size * 0.4))
                    .foregroundColor(color)
                
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
