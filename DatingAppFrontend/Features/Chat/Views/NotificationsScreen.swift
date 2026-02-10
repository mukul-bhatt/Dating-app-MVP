//
//  NotificationsScreen.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 09/02/26.
//


import SwiftUI

struct NotificationsScreen: View {
    @State private var selectedTab = "All"
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Custom Segmented Picker
            HStack(spacing: 0) {
                PickerButton(title: "All", isSelected: selectedTab == "All") {
                    selectedTab = "All"
                }
                PickerButton(title: "Matches", isSelected: selectedTab == "Matches") {
                    selectedTab = "Matches"
                }
            }
            .padding(4)
            .background(Color.white)
            .cornerRadius(25)
            .padding()
            
            ScrollView {
                VStack(spacing: 0) {
                    // New Match Row
                    NotificationRow(imageName: "user1", text: "You have a new match with Alex!") {
                        HStack {
                            ActionButton(title: "View Profile 🤗")
                            ActionButton(title: "Send Message 📧")
                        }
                    }
                    
                    // Message Row
                    NotificationRow(imageName: "user2", text: "New message from Ryan: 'Hey, how's your day?'") {
                        ActionButton(title: "Send Message 📧")
                    }
                    
                    // Profile Waiting Row (Overlapping images)
                    NotificationRow(imageName: "group", text: "You have 3 new profiles waiting - Check them out !", hasOverlappingImages: true) {
                        EmptyView()
                    }
                    
                    // Like Row
                    NotificationRow(imageName: "user1", text: "Ajay Kumar has liked your profile") {
                        HStack {
                            ActionButton(title: "Like back ❤️")
                            ActionButton(title: "Decline 🙅")
                        }
                    }
                }
            }
        }
        .background(AppTheme.backgroundPink) // Light pink background
    }
}

// MARK: - Supporting Views

struct PickerButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(isSelected ? AppTheme.foregroundPink : Color.clear)
                .foregroundColor(isSelected ? .white : .black)
                .cornerRadius(20)
        }
    }
}

struct NotificationRow<Content: View>: View {
    let imageName: String
    let text: String
    var hasOverlappingImages: Bool = false
    let actions: Content
    
    init(imageName: String, text: String, hasOverlappingImages: Bool = false, @ViewBuilder actions: () -> Content) {
        self.imageName = imageName
        self.text = text
        self.hasOverlappingImages = hasOverlappingImages
        self.actions = actions()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 15) {
                if hasOverlappingImages {
                    overlappingAvatars
                } else {
                    Circle()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.gray.opacity(0.3))
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(text)
                        .font(.system(size: 16))
                        .lineSpacing(4)
                    
                    actions
                }
            }
            .padding()
            
            Divider()
        }
    }
    
    var overlappingAvatars: some View {
        ZStack {
            ForEach(0..<3) { i in
                Circle()
                    .frame(width: 35, height: 35)
                    .foregroundColor(.gray.opacity(Double(i+1) * 0.2))
                    .overlay(Circle().stroke(Color.white, lineWidth: 1))
                    .offset(x: CGFloat(i * 15))
            }
        }
        .frame(width: 65, height: 35, alignment: .leading)
    }
}

struct ActionButton: View {
    let title: String
    let color = AppTheme.foregroundPink
    
    var body: some View {
        Text(title)
            .font(.system(size: 13, weight: .medium))
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(color)
            .cornerRadius(5)
    }
}


#Preview{
    NotificationsScreen()
}
