//
//  ProfileSetupHeader.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 11/01/26.
//


import SwiftUI
    
    struct ProfileSetupHeader: View {
        var body: some View {
            VStack(spacing: 12) {
                Text("Setup your Profile")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.primary)
                
                Text("Tell us a little about yourself — the better we know you, the better your feed gets.")
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 24)
//            .padding(.top, 30)
        }
    }
