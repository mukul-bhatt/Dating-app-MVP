//
//  DiscoverView.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 19/01/26.
//

import SwiftUI

// MARK: - Main View
struct DiscoverView: View {
    var body: some View {
        ZStack {
            Color(hex: "FDE5E7") // Light pink background
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                TopBarView()
                
                Spacer()
                
                // Card Stack
                ZStack {
                    // Background cards (slightly offset and rotated)
                    CardView(imageName: "person2", name: "", age: "", distance: "", matchPercentage: 0, showInfo: false)
                        .offset(x: 30, y: -20)
                        .rotationEffect(.degrees(3))
                        .opacity(0.7)
                    
                    CardView(imageName: "person3", name: "", age: "", distance: "", matchPercentage: 0, showInfo: false)
                        .offset(x: -30, y: -20)
                        .rotationEffect(.degrees(-3))
                        .opacity(0.7)
                    
                    // Foreground card
                    CardView(imageName: "nia", name: "Nia Sharma", age: "26", distance: "2km away", matchPercentage: 89, showInfo: true)
                }
                .padding(.horizontal, 20)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                
                Spacer()
                
                ActionButtonsView()
                
                Spacer()
                
                BottomTabBarView()
            }
        }
    }
}

// MARK: - Top Bar
struct TopBarView: View {
    var body: some View {
        HStack {
            Text("Discover")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Color(hex: "E85078"))
            Spacer()
            Button(action: { }) {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 24))
                    .foregroundColor(Color(hex: "E85078"))
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 10)
    }
}

// MARK: - Card View
struct CardView: View {
    var imageName: String
    var name: String
    var age: String
    var distance: String
    var matchPercentage: Int
    var showInfo: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            if showInfo {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 380)
                    .clipped()
            } else {
                Color(hex: "E85078").opacity(0.3) // Placeholder for background cards
                    .frame(height: 380)
            }
            
            if showInfo {
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("\(name) ,\(age)")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                        HStack(spacing: 5) {
                            Image(systemName: "mappin.and.ellipse")
                                .foregroundColor(.white)
                            Text(distance)
                                .foregroundColor(.white)
                                .font(.system(size: 16))
                        }
                    }
                    Spacer()
                    HStack {
                        Image(systemName: "heart.fill")
                            .foregroundColor(Color(hex: "E85078"))
                        Text("\(matchPercentage)%")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(hex: "E85078"))
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 8)
                    .background(Color.white)
                    .cornerRadius(20)
                }
                .padding()
                .background(Color(hex: "E85078"))
            }
        }
        .cornerRadius(20)
        .aspectRatio(0.75, contentMode: .fit)
    }
}

// MARK: - Action Buttons
struct ActionButtonsView: View {
    var body: some View {
        HStack(spacing: 30) {
            Button(action: {}) {
                Image(systemName: "xmark")
                    .font(.system(size: 28, weight: .medium))
                    .foregroundColor(Color(hex: "E85078"))
                    .frame(width: 70, height: 70)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
            }
            
            Button(action: {}) {
                Image(systemName: "envelope.fill")
                    .font(.system(size: 32, weight: .medium))
                    .foregroundColor(Color(hex: "E85078"))
                    .frame(width: 80, height: 80)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                    .overlay(
                        Image(systemName: "heart.fill")
                            .font(.system(size: 16))
                            .foregroundColor(Color(hex: "E85078"))
                            .offset(y: -10)
                    )
            }
            
            Button(action: {}) {
                Image(systemName: "checkmark")
                    .font(.system(size: 28, weight: .medium))
                    .foregroundColor(Color(hex: "E85078"))
                    .frame(width: 70, height: 70)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
            }
        }
        .padding(.bottom, 20)
    }
}

// MARK: - Bottom Tab Bar
struct BottomTabBarView: View {
    var body: some View {
        HStack(spacing: 0) {
            Button(action: {}) {
                Image(systemName: "infinity")
                    .font(.system(size: 24))
                    .foregroundColor(Color(hex: "E85078"))
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
            }
            .background(Color.white)
            
            Button(action: {}) {
                Image(systemName: "sparkles")
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
            }
            .background(Color(hex: "E85078"))
            
            Button(action: {}) {
                Image(systemName: "bell.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
            }
            .background(Color(hex: "E85078"))
            
            Button(action: {}) {
                Image(systemName: "person.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
            }
            .background(Color(hex: "E85078"))
        }
        .cornerRadius(30)
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: -2)
    }
}

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Preview
struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}
