//
//  SettingUpScreen.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 18/01/26.
//


import SwiftUI

struct SettingUpScreen: View {
    var title = "Setting up your Profile"
    var subTitle = "This may take a while, Please wait."
    
    var body: some View {
        ZStack {
            // 1. Background Color
            Color("BrandColor") // Light Pink
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                
                // 2. The Animated Heart
                FillingHeartView(
                    color: Color(red: 0.96, green: 0.28, blue: 0.60), // Hot Pink
                    duration: 2.0
                )
                .frame(width: 120, height: 120)
                
                // 3. The Text Labels
                VStack(spacing: 12) {
                    Text(title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.2, green: 0.05, blue: 0.1))
                    
                    Text(subTitle)
                        .font(.subheadline)
                        .foregroundColor(.black.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
            }
        }
    }
}

// MARK: - Custom Animated Heart Component
struct FillingHeartView: View {
    let color: Color
    let duration: Double
    
    // Animation State
    @State private var fillHeight: CGFloat = 0.0
    
    var body: some View {
        ZStack {
            // Layer A: The Empty Heart Outline (Background)
            Image(systemName: "heart")
                .resizable()
                .scaledToFit()
                .font(Font.title.weight(.light))
                .foregroundColor(color)
                .opacity(0.3)
            
            // Layer B: The Filling Animation
            // We create a rectangle (the "liquid") and mask it with the heart shape
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    Rectangle()
                        .fill(color)
                        .frame(height: geometry.size.height * fillHeight)
                }
            }
            .mask(
                Image(systemName: "heart.fill")
                    .resizable()
                    .scaledToFit()
            )
            
            // Layer C: The Stroke Outline (Foreground overlay for crisp edges)
            Image(systemName: "heart")
                .resizable()
                .scaledToFit()
                .font(Font.title.weight(.medium)) // Make outline slightly thicker
                .foregroundColor(color)
        }
        .onAppear {
            // The Animation Logic
            withAnimation(
                Animation
                    .linear(duration: duration)
                    .repeatForever(autoreverses: false) // Restarts when done
            ) {
                fillHeight = 1.0 // Animate from 0% to 100% height
            }
        }
    }
}

//#Preview {
//    SettingUpScreen()
//}
