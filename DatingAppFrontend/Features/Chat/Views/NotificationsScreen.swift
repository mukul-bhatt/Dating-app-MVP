//
//  NotificationsScreen.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 09/02/26.
//


import SwiftUI

struct NotificationsScreen: View {
    @State private var selectedTab = "All"
    @EnvironmentObject var notificationsManager: NotificationsManager
    
    var body: some View {
        NavigationStack {
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
                        if notificationsManager.notifications.isEmpty {
                            VStack(spacing: 20) {
                                Spacer(minLength: 50)
                                Image(systemName: "bell.slash")
                                    .font(.system(size: 50))
                                    .foregroundColor(.gray.opacity(0.5))
                                Text("No new notifications")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                            }
                        } else {
                            ForEach(notificationsManager.notifications) { notification in
                                NotificationRow(
                                    imageUrl: notification.senderImageUrl,
                                    text: "New message from \(notification.senderName): '\(notification.message)'"
                                ) {
                                    NavigationLink {
                                        ChatView(
                                            conversationId: notification.conversationId ?? 0,
                                            receiverId: notification.senderId,
                                            receiverName: notification.senderName,
                                            receiverImageURL: notification.senderImageUrl,
                                            initialMessage: notification.message
                                        )
                                    } label: {
                                        ActionButton(title: "View Message 📧")
                                    }
                                }
                            }
                        }
                        
                        // Legacy/Mock rows for other types (Matches, etc)
//                        if selectedTab == "All" || selectedTab == "Matches" {
//                             NotificationRow(imageName: "user1", text: "Alex has liked your profile") {
//                                 ActionButton(title: "Like back ❤️")
//                             }
//                        }
                    }
                }
            }
            .background(AppTheme.backgroundPink)
            .onAppear {
                notificationsManager.clearUnreadCount()
            }
        }
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
    let imageUrl: URL?
    let imageName: String?
    let text: String
    var hasOverlappingImages: Bool = false
    let actions: Content
    
    // Remote Image Init
    init(imageUrl: URL?, text: String, hasOverlappingImages: Bool = false, @ViewBuilder actions: () -> Content) {
        self.imageUrl = imageUrl
        self.imageName = nil
        self.text = text
        self.hasOverlappingImages = hasOverlappingImages
        self.actions = actions()
    }
    
    // Asset Image Init (Legacy)
    init(imageName: String, text: String, hasOverlappingImages: Bool = false, @ViewBuilder actions: () -> Content) {
        self.imageUrl = nil
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
                    if let url = imageUrl {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                        } placeholder: {
                            Circle()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.gray.opacity(0.3))
                        }
                    } else if let name = imageName {
                        Image(name)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    } else {
                        Circle()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.gray.opacity(0.3))
                    }
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
