//
//  Profile.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 21/01/26.
//


import SwiftUI


var backgroundPink = Color("BrandColor")
var foregroundPink = Color("ButtonColor")

// MARK: - Models
//struct Profile: Identifiable {
//    let id = UUID()
//    let name: String
//    let age: Int
//    let distance: String
//    let matchPercentage: Int
//    let imageName: String
//}

// MARK: - Main View
struct DiscoverView: View {
//    @State private var profiles = [
//        Profile(name: "Nia Sharma", age: 26, distance: "2km away", matchPercentage: 89, imageName: "person1"),
//        Profile(name: "Sarah Johnson", age: 24, distance: "5km away", matchPercentage: 92, imageName: "person2"),
//        Profile(name: "Emma Wilson", age: 28, distance: "3km away", matchPercentage: 85, imageName: "person3")
//    ]
    
    @State private var dragOffset: CGSize = .zero
    @State private var rotation: Double = 0
    
    
    
    
    var body: some View {
        ZStack {
            // Background
            Color(backgroundPink)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                DiscoverHeader()
                Spacer()
                
                // Card Stack
//                ZStack {
//                    ForEach(profiles.indices.reversed(), id: \.self) { index in
//                        if index < 3 {
//                            ProfileCard(profile: profiles[index])
//                                .offset(y: CGFloat(index * 10))
//                                .scaleEffect(1 - CGFloat(index) * 0.05)
//                                .opacity(index == 0 ? 1 : 0.5)
//                                .offset(x: index == 0 ? dragOffset.width : 0)
//                                .rotationEffect(.degrees(index == 0 ? rotation : 0))
//                                .gesture(
//                                    index == 0 ? DragGesture()
//                                        .onChanged { value in
//                                            dragOffset = value.translation
//                                            rotation = Double(value.translation.width / 20)
//                                        }
//                                        .onEnded { value in
//                                            let threshold: CGFloat = 100
//                                            if abs(value.translation.width) > threshold {
//                                                // Swipe action
////                                                removeCard()
//                                            } else {
//                                                // Reset
//                                                withAnimation(.spring()) {
//                                                    dragOffset = .zero
//                                                    rotation = 0
//                                                }
//                                            }
//                                        } : nil
//                                )
//                        }
//                    }
//                }
//                .frame(height: 500)
//                .padding(.horizontal, 20)
                
                // Action Buttons
//                HStack(spacing: 30) {
//                    Button(action: { handleReject() }) {
//                        Image(systemName: "xmark")
//                            .font(.system(size: 28, weight: .bold))
//                            .foregroundColor(Color(red: 0.9, green: 0.3, blue: 0.5))
//                            .frame(width: 70, height: 70)
//                            .background(Color.white)
//                            .clipShape(Circle())
//                            .shadow(color: .black.opacity(0.1), radius: 10)
//                    }
                    
//                    Button(action: { handleLike() }) {
//                        ZStack {
//                            Image(systemName: "envelope.fill")
//                                .font(.system(size: 32, weight: .bold))
//                                .foregroundColor(.white)
//                            Image(systemName: "heart.fill")
//                                .font(.system(size: 20, weight: .bold))
//                                .foregroundColor(.white)
//                                .offset(y: 2)
//                        }
//                        .frame(width: 80, height: 80)
//                        .background(
//                            LinearGradient(
//                                colors: [Color(red: 0.9, green: 0.3, blue: 0.5), Color(red: 0.8, green: 0.2, blue: 0.4)],
//                                startPoint: .topLeading,
//                                endPoint: .bottomTrailing
//                            )
//                        )
//                        .clipShape(Circle())
//                        .shadow(color: Color(red: 0.9, green: 0.3, blue: 0.5).opacity(0.4), radius: 15)
//                    }
                    
//                    Button(action: { handleSuperLike() }) {
//                        Image(systemName: "checkmark")
//                            .font(.system(size: 28, weight: .bold))
//                            .foregroundColor(Color(red: 0.9, green: 0.3, blue: 0.5))
//                            .frame(width: 70, height: 70)
//                            .background(Color.white)
//                            .clipShape(Circle())
//                            .shadow(color: .black.opacity(0.1), radius: 10)
//                    }
//                }
//                .padding(.vertical, 30)
                
                Spacer()
                
                // Bottom Navigation
//                HStack(spacing: 0) {
//                    TabButton(icon: "flame.fill", isActive: true)
//                    TabButton(icon: "message.fill", isActive: false)
//                    TabButton(icon: "bell.fill", isActive: false)
//                    TabButton(icon: "person.2.fill", isActive: false)
//                }
//                .frame(height: 70)
//                .background(
//                    LinearGradient(
//                        colors: [Color(red: 0.9, green: 0.3, blue: 0.5), Color(red: 0.8, green: 0.2, blue: 0.4)],
//                        startPoint: .leading,
//                        endPoint: .trailing
//                    )
//                    .cornerRadius(35)
//                )
//                .padding(.horizontal, 30)
//                .padding(.bottom, 20)
            }
            .padding(.horizontal)
            .padding(.top, 20)
        }
    }
    
//    func removeCard() {
//        withAnimation(.spring()) {
//            dragOffset = .zero
//            rotation = 0
//            profiles.removeFirst()
//        }
//    }
//    
//    func handleReject() {
//        withAnimation(.spring()) {
//            dragOffset = CGSize(width: -500, height: 0)
//            rotation = -20
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//            removeCard()
//        }
//    }
//    
//    func handleLike() {
//        withAnimation(.spring()) {
//            dragOffset = CGSize(width: 500, height: 0)
//            rotation = 20
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//            removeCard()
//        }
//    }
//    
//    func handleSuperLike() {
//        withAnimation(.spring()) {
//            dragOffset = CGSize(width: 0, height: -500)
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//            removeCard()
//        }
//    }
}

// MARK: - HEADER
struct DiscoverHeader: View {
    var body: some View {
        HStack {
            Spacer()
            Text("Discover")
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(foregroundPink)
            Spacer()
            Button(action: {}) {
                Image(systemName: "slider.horizontal.3")
                    .font(.title3)
                    .foregroundColor(.primary)
            }
        }
    }
}

// MARK: - Tab Button
//struct TabButton: View {
//    let icon: String
//    let isActive: Bool
//    
//    var body: some View {
//        Button(action: {}) {
//            Image(systemName: icon)
//                .font(.system(size: 22))
//                .foregroundColor(.white)
//                .frame(maxWidth: .infinity)
//        }
//    }
//}

// MARK: - Preview
struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}
