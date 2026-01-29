//
//  MatchView.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 29/01/26.
//


import SwiftUI

struct MatchView: View {
    @Environment(\.dismiss) var dismiss
    let matchedUserName: String = "Nia"
    
    // MARK: - Colors
    let brandPink = Color(red: 223/255, green: 70/255, blue: 118/255)
    
    var body: some View {
        ZStack {
            // 1. Background
            brandPink.ignoresSafeArea()
            
            // 2. Decorative Floating Hearts
            // Use an overlay or background ZStack for the hand-drawn hearts
            BackgroundHeartsView()
            
            VStack(spacing: 30) {
                Spacer()
                
                // 3. Title
                Text("IT'S A MATCH !")
                    .font(.custom("Marker Felt", size: 40)) // Or a similar playful font
                    .fontWeight(.black)
                    .foregroundColor(.white)
                
                // 4. Overlapping Profile Images
                HStack(spacing: -30) {
                    // Your Profile
                    CircularProfileImage(imageName: "user_me", size: 160)
                        .offset(y: -20)
                    
                    // Matched User Profile
                    CircularProfileImage(imageName: "user_nia", size: 160)
                        .offset(y: 40)
                }
                .padding(.vertical, 20)
                
                // 5. Match Text
                Text("You Matched with \(matchedUserName) 😍")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Spacer()
                
                // 6. Action Buttons
                VStack(spacing: 16) {
                    Button(action: {
                        // Navigate to Chat
                    }) {
                        Text("Say Hi!")
                            .font(.headline)
                            .foregroundColor(brandPink)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .clipShape(Capsule())
                    }
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Keep Swiping")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .clipShape(Capsule())
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Supporting Views

struct CircularProfileImage: View {
    let imageName: String
    let size: CGFloat
    
    var body: some View {
        Image(imageName) // Use your asset names
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size, height: size)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 4))
            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

struct BackgroundHeartsView: View {
    var body: some View {
        ZStack {
            // Randomly placed hearts matching the design
            Image(systemName: "heart")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(.white.opacity(0.4))
                .rotationEffect(.degrees(-15))
                .position(x: 80, y: 150)
            
            Image(systemName: "heart")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(.white.opacity(0.4))
                .rotationEffect(.degrees(20))
                .position(x: 350, y: 120)
            
            Image(systemName: "heart")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.white.opacity(0.4))
                .position(x: 40, y: 400)
            
            // Add more as per the screenshot...
        }
        .ignoresSafeArea()
    }
}

#Preview {
    MatchView()
}