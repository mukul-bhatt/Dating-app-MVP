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
    
    var body: some View {
        ZStack {
            // Background
            Color(backgroundPink)
                .ignoresSafeArea()
            
            VStack {
                // Header
//                ScrollView{
                    DiscoverHeader()
                    
                    Spacer()
                    
                    ProfileCard()
                    Spacer()
                    
                    ActionButtons()
                    Spacer()
                    
//                }
//                MainTabView()
//                 Bottom Navigation
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
}

// MARK: - Buttons Section
struct ActionButtons: View {
    var body: some View {
        HStack(spacing: 40) {
            // Decline/Pass Button
            Button(action: {
                print("Pass")
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color(red: 0.91, green: 0.33, blue: 0.55))
                    .frame(width: 60, height: 60)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            }
            
            // Super Like/Message Button
            Button(action: {
                print("Super Like")
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(red: 0.91, green: 0.33, blue: 0.55))
                        .frame(width: 80, height: 60)
                    
                    Image("EnvelopeIcon")
                        .renderingMode(.template)
                        .font(.system(size: 26))
                        .foregroundColor(.white)
                        .clipShape(Circle())
                    
//                    Image(systemName: "heart.fill")
//                        .font(.system(size: 18))
//                        .foregroundColor(.white)
//                        .offset(x: -8, y: -8)
                }
                .shadow(color: Color(red: 0.91, green: 0.33, blue: 0.55).opacity(0.4), radius: 8, x: 0, y: 4)
            }
            
            // Like/Accept Button
            Button(action: {
                print("Like")
            }) {
                Image(systemName: "checkmark")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color(red: 0.91, green: 0.33, blue: 0.55))
                    .frame(width: 60, height: 60)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            }
        }
    }
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
struct TabButton: View {
    let icon: String
    let isActive: Bool
    
    var body: some View {
        Button(action: {}) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - Preview
struct DiscoverView_Previews: PreviewProvider {
    
    static var previews: some View {
        TabView {
            DiscoverView()
                .tabItem {
                    Image("HeartIcon_tabBar")
                }
            DiscoverView()
                .tabItem {
                    Image("ChatIcon").renderingMode(.template)
                }

            LandingScreenView()
                .tabItem {
                    Image("NotificationIcon")
                }

            LandingScreenView()
                .tabItem {
                    Image("ProfileIcon")

                }
        }
        .tint(.pink)
    }
}

//import SwiftUI

//struct MainTabView: View {
//    var body: some View {
//        TabView {
//            DiscoverView()
//                .tabItem {
//                    Image(systemName: "house.fill")
//                    Text("Home")
//                }
//
//            LandingScreenView()
//                .tabItem {
//                    Image(systemName: "magnifyingglass")
//                    Text("Search")
//                }
//
//            LandingScreenView()
//                .tabItem {
//                    Image(systemName: "person.fill")
//                    Text("Profile")
//                }
//        }
//    }
//}




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
