//
//  ActionButtonsProfile.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 28/01/26.
//

import SwiftUI

struct ActionButtonsProfile: View {
    
    var onDislike: (() async -> Void)? = nil
    var onLike: (() async -> Void)? = nil
    var onMessage: (() -> Void)? = nil
    var isLiked: Bool = false
    
    var body: some View {
        HStack(spacing: 30) {
            Spacer()
            
            // Pass Button (always shown)
            CircularButton(icon: "HeartSlashIcon", color: AppTheme.foregroundPink, actionToPerform: onDislike)
            
            // Message button (match flow) OR Like button (normal flow)
            if let onMessage = onMessage {
                CircularButton(
                    icon: "MessageIcon",
                    color: AppTheme.foregroundPink,
                    syncAction: onMessage
                )
            } else {
                CircularButton(
                    icon: isLiked ? "heart.fill" : "heart",
                    color: AppTheme.foregroundPink,
                    isSystemIcon: true,
                    actionToPerform: onLike
                )
            }
            
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
    var syncAction: (() -> Void)? = nil

    var body: some View {
        Button {
            if let syncAction = syncAction {
                syncAction()
            } else if let actionToPerform = actionToPerform {
                Task {
                    await actionToPerform()
                }
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
            }
            .frame(width: size, height: size)
        }
    }
}
