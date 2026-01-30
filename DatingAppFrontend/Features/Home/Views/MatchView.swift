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
    let brandPink = AppTheme.foregroundPink
    
    var body: some View {
        ZStack {
            // 1. Background
            MatchBackground()
            
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
                    CircularProfileImage(imageName: "Image8", size: 160)
                        .offset(y: -20)
                    
                    // Matched User Profile
                    CircularProfileImage(imageName: "Image4", size: 160)
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
                            .foregroundColor(.primary)
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
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white.opacity(0.5))
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
            Image("IconPark")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(.white.opacity(0.4))
                .rotationEffect(.degrees(-15))
                .position(x: 80, y: 150)
            
            Image("IconPark")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(.white.opacity(0.4))
                .rotationEffect(.degrees(20))
                .position(x: 350, y: 150)
            
            Image("IconPark")
                .resizable()
                .frame(width: 70, height: 70)
                .foregroundColor(.white.opacity(0.4))
                .rotationEffect(.degrees(20))
                .position(x: 250, y: 280)
            
            Image("IconPark")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.white.opacity(0.4))
                .rotationEffect(.degrees(20))
                .position(x: 350, y: 300)
            
            Image("IconPark")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(.white.opacity(0.4))
                .rotationEffect(.degrees(20))
                .position(x: 200, y: 120)
            
            Image("IconPark")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.white.opacity(0.4))
                .position(x: 45, y: 280)
            
            Image("IconPark")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.white.opacity(0.4))
                .position(x: 40, y: 400)
            
            Image("IconPark")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.white.opacity(0.4))
                .position(x: 40, y: 500)
            
            Image("IconPark")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.white.opacity(0.4))
                .position(x: 350, y: 500)
            
            // Add more as per the screenshot...
        }
        .ignoresSafeArea()
    }
}


struct MatchBackground: View {
    // Colors from your CSS hex codes
    let startColor = Color("StartColor")
    let endColor = Color("EndColor")
    
    
    var body: some View {
        
        GeometryReader { geometry in
            let largestDimension = max(geometry.size.width, geometry.size.height)
            
            RadialGradient(
                gradient: Gradient(colors: [startColor, endColor]),
                center: .center,
                startRadius: 0,
                endRadius: largestDimension / 2
            )
        }
        .ignoresSafeArea()

    }
}

#Preview {
    MatchView()
}
