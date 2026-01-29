//
//  ProfileCard.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 21/01/26.

import SwiftUI

struct ProfileCard: View {
    @State private var offset: CGSize = .zero
    @State private var lastOffset = CGSize.zero
    @State private var lastTime = Date()
    let profile: DiscoverProfile
    let onSwipe: (SwipeDirection) async ->Void
    
    
    @Binding var triggerSwipe: SwipeDirection?
    
    
    let defaultImageUrl = "https://images.pexels.com/photos/3448813/pexels-photo-3448813.jpeg"
    var body: some View {
        
        ZStack(alignment: .bottomLeading) {
            // Profile Image
//            Image("NiaSharma")
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .frame(width: 350, height: 400)
//                .clipped()
//                .cornerRadius(20)
            
            AsyncImage(url: URL(string: profile.profileImagesArray.count != 0 ? profile.profileImagesArray[0] : defaultImageUrl )) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray // Displays while loading
                }
                .frame(width: 350, height: 400)
                .clipped()
                .cornerRadius(20)
            
            // Gradient overlay
            LinearGradient(
                gradient: Gradient(colors: [.clear, .black.opacity(0.7)]),
                startPoint: .center,
                endPoint: .bottom
            )
            .cornerRadius(20)
            
            // Info overlay
            
            HStack{
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("\(profile.fullName), \(profile.displayAge)")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    
                    // Distance
                    HStack(spacing: 4) {
                        Image(systemName: "location.fill")
                            .font(.title3)
                            .foregroundColor(.white)
                        
                        Text("\(profile.distanceInKM)km away")
                            .font(.callout)
                            .foregroundColor(.white)
                    }
                    
                }
                .padding(.horizontal,20)
                .padding(.vertical, 10)
                
                // Match percentage
                    HStack(spacing: 6) {
                        Image("HeartIcon")
                            .font(.callout)
                            .foregroundColor(.black)

                        Text("\(profile.matchPercent)%")
                            .font(.callout)
                            .foregroundColor(.primary)
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 8)
                    .background(Color("BrandColor"))
                    .cornerRadius(20)
                
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Color("ButtonColor"))
           
        }
        .frame(width: 350, height: 400)
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
        .cornerRadius(20)
        .offset(x: offset.width, y: offset.height)
        .rotationEffect(.degrees(Double(offset.width / -30)))
        .onChange(of: triggerSwipe) { oldValue, newValue in
                        if let direction = newValue {
                            performSwipe(direction: direction)
                            triggerSwipe = nil
                        }
                    }
        .gesture(
                    DragGesture()
                            .onChanged { gesture in
                                offset = gesture.translation
                                
                                // Track velocity by storing recent position and time
                                let now = Date()
                                let timeDiff = now.timeIntervalSince(lastTime)
                                
                                // Update tracking every 0.05 seconds to get recent velocity
                                if timeDiff > 0.05 {
                                    lastOffset = offset
                                    lastTime = now
                                }
                            }
                            .onEnded { _ in
                                // Calculate velocity (points per second)
                                let timeDiff = Date().timeIntervalSince(lastTime)
                                let velocity = (offset.width - lastOffset.width) / CGFloat(timeDiff)
                                
                                // Thresholds
                                let distanceThreshold: CGFloat = 300
                                let velocityThreshold: CGFloat = 500 // points per second
                                
                                // Check if swipe threshold is met (distance OR velocity)
                                if abs(offset.width) > distanceThreshold || abs(velocity) > velocityThreshold {
                                    // Determine direction
                                    let direction: SwipeDirection = offset.width > 0 ? .right : .left
                                    
                                    // Swipe successful - fly off screen
                                    offset = CGSize(
                                        width: offset.width > 0 ? 500 : -500,
                                        height: offset.height
                                    )
                                    
                                    // Notify parent after a brief delay for animation
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                                            onSwipe(direction)
                                        Task {
                                                await onSwipe(direction)
                                            }
                                        }
                                } else {
                                    // Snap back to center
                                    offset = .zero
                                }
                                
                                // Reset tracking
                                lastOffset = .zero
                                lastTime = Date()
                            }
                    )
                    .animation(.spring(), value: offset)
    }
    
    private func performSwipe(direction: SwipeDirection) {
            // Animate card flying away
            offset = CGSize(
                width: direction == .right ? 500 : -500,
                height: offset.height
            )
            
            // Call the callback after brief delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                onSwipe(direction)
                Task {
                        await onSwipe(direction)
                    }
            }
        }
    
}

//struct ContentView: View {
//    var body: some View {
//        ZStack {
//            Color.gray.opacity(0.1)
//                .ignoresSafeArea()
//            
//            ProfileCard()
//        }
//    }
//}
//
//#Preview {
//    ContentView()
//}

