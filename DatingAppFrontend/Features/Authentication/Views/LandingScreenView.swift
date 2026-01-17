//
//  LandingScreenView.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 08/01/26.
//


import SwiftUI

struct LandingScreenView: View {
    @StateObject private var viewModel = ProfileViewModel()
    
    // MARK: - Properties
    // Using the colors derived from your previous files/images
    let brandGradientColors = [
        Color(red: 0.95, green: 0.85, blue: 0.85), // Peach/Light top
        Color(red: 0.90, green: 0.35, blue: 0.55), // Mid Pink
        Color(red: 0.85, green: 0.25, blue: 0.45)  // Dark Pink bottom
    ]
    
    var body: some View {
        NavigationStack{
            ZStack {
                // 1. Main Background Gradient
                LinearGradient(
                    gradient: Gradient(colors: brandGradientColors),
                    startPoint: .topLeading,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    
                    // 2. The Masonry Photo Grid
                    // We use a geometry reader to make it take roughly 60% of the screen
                    GeometryReader { geo in
                        MasonryPhotoGrid()
                        // Add a fade-to-bottom effect so images blend into the pink
                            .mask(
                                LinearGradient(
                                    gradient: Gradient(stops: [
                                        .init(color: .black, location: 0.0),
                                        .init(color: .black, location: 0.6),
                                        .init(color: .clear, location: 1.0)
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(height: geo.size.height) // Uses available geometry height
                    }
                    .ignoresSafeArea(edges: .top)
                    
                    Spacer() // Pushes content up
                    
                    // 3. Text and Actions Area
                    VStack(spacing: 25) {
                        
                        // Headline
                        Text("Swipe. Spark. Smile.")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        // Subhead
                        Text("Live. Unfiltered. Personal. Discover attraction beyond the swipe.")
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white.opacity(0.9))
                            .padding(.horizontal, 40)
                            .lineSpacing(4)
                        
                        // Create Account Button
                        
                        NavigationLink(destination: RegisterWithUsView(viewModel: viewModel)) {
                            Text("Create Account")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color.white)
                                .cornerRadius(30)
                        }
                        .padding(.horizontal, 30)
                        .padding(.top, 10)
                        
                        // Login Link
                        HStack(spacing: 5) {
                            Text("Already have an account?")
                                .foregroundColor(.white.opacity(0.8))
                            
                            NavigationLink(destination: LoginView(viewModel: viewModel)){
                                Text("LOGIN")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .underline()
                            }
                        }
                        .font(.callout)
                        .padding(.bottom, 20)
                    }
                    .padding(.bottom, 20)
                }
            }
        }
    }
}

// MARK: - Subcomponents

struct MasonryPhotoGrid: View {
    // Defines the layout of 3 columns
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            
            // Column 1
            VStack(spacing: 12) {
                MockImage(height: 200, color: .purple)
                MockImage(height: 150, color: .orange)
                MockImage(height: 180, color: .pink)
            }
            
            // Column 2
            VStack(spacing: 12) {
                MockImage(height: 140, color: .yellow)
                MockImage(height: 180, color: .green)
                
                // The Image with the Logo Overlay
                ZStack {
                    MockImage(height: 160, color: .blue)
                    
                    // Heart Cluster Logo
                    Image(systemName: "heart.circle.fill") // Replace with "appIcon"
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                }
            }
            .padding(.top, 40) // Offset the middle column slightly
            
            // Column 3
            VStack(spacing: 12) {
                MockImage(height: 180, color: .red)
                MockImage(height: 220, color: .teal)
                MockImage(height: 140, color: .indigo)
            }
        }
        .padding(.horizontal, 10)
        .rotationEffect(.degrees(-5)) // Slight tilt for style
        .scaleEffect(1.1) // Zoom in slightly to cover edges
    }
}

// Helper to simulate the photos from your screenshot
struct MockImage: View {
    let height: CGFloat
    let color: Color
    
    var body: some View {
        // In a real app, replace Color with Image("assetName")
        Rectangle()
            .fill(color.opacity(0.6)) // Opacity to mimic the faded photo look
            .overlay(
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40)
                    .foregroundColor(.white.opacity(0.4))
            )
            .frame(height: height)
            .cornerRadius(12)
            // This blends the image with the pink theme
            .colorMultiply(Color(red: 1.0, green: 0.9, blue: 0.95))
    }
}

// MARK: - Preview
#Preview {
    LandingScreenView()
}

