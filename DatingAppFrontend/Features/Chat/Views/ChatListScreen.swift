import SwiftUI

struct ChatListScreen: View {
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Header
            headerView
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Online")
                        .font(.headline)
                        .padding(.horizontal)
                        .padding(.top)

                    // MARK: - Online Stories Row
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(0..<3) { _ in
                                OnlineCircleView()
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // MARK: - Chat List
                    VStack(spacing: 0) {
                        ForEach(0..<5) { _ in
                            ChatRowView()
                            Divider()
                                .padding(.leading, 80)
                                .padding(.trailing)
                        }
                    }
                }
            }
            .background(Color(red: 1.0, green: 0.9, blue: 0.94)) // Light pink background
            
            // MARK: - Custom Bottom Tab Bar
            customTabBar
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    var headerView: some View {
        HStack {
            Image(systemName: "arrow.left")
            Text("Chats")
                .font(.title3)
                .fontWeight(.medium)
            Spacer()
        }
        .padding()
        .foregroundColor(.white)
        .background(Color(red: 0.85, green: 0.25, blue: 0.45))
    }
    
    var customTabBar: some View {
        HStack(spacing: 0) {
            TabBarIcon(icon: "heart.fill", isSelected: false)
            TabBarIcon(icon: "bubble.left.fill", isSelected: true) // The active white tab
            TabBarIcon(icon: "bell.fill", isSelected: false)
            TabBarIcon(icon: "person.fill", isSelected: false)
        }
        .frame(height: 80)
        .background(Color(red: 0.85, green: 0.25, blue: 0.45))
        .cornerRadius(30, corners: [.topLeft, .topRight, .bottomLeft, .bottomRight])
        .padding(.horizontal)
        .padding(.bottom, 30)
    }
}

// MARK: - Subviews

struct OnlineCircleView: View {
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Circle()
                .frame(width: 65, height: 65)
                .foregroundColor(.gray.opacity(0.3)) // Replace with Image
            
            Circle()
                .frame(width: 14, height: 14)
                .foregroundColor(.green)
                .overlay(Circle().stroke(Color.white, lineWidth: 2))
        }
    }
}

struct ChatRowView: some View {
    var body: some View {
        HStack(spacing: 15) {
            Circle()
                .frame(width: 55, height: 55)
                .foregroundColor(.gray.opacity(0.3)) // Replace with Image
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Mahika Malik")
                    .font(.system(size: 16, weight: .bold))
                Text("Good, I saw it just now")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text("9:56 AM")
                .font(.system(size: 12))
                .foregroundColor(.black)
        }
        .padding()
    }
}

struct TabBarIcon: some View {
    let icon: String
    let isSelected: Bool
    
    var body: some View {
        ZStack {
            if isSelected {
                Rectangle()
                    .fill(Color.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(isSelected ? Color(red: 0.85, green: 0.25, blue: 0.45) : .white.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
    }
}