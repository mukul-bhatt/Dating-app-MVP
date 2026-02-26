//
//  NotificationsScreen.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 09/02/26.
//


import SwiftUI

struct NotificationsScreen: View {
    @State private var selectedTab = "All"
    @State private var path = NavigationPath()
    @StateObject var discoverViewModel = DiscoverViewModel()
    @EnvironmentObject var notificationsManager: NotificationsManager
    
    var body: some View {
        NavigationStack(path: $path) {
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
                        let filteredNotifications = notificationsManager.notifications.filter { notification in
                            if selectedTab == "Matches" {
                                return notification.notificationType == "match"
                            }
                            return true // "All" tab
                        }
                        
                        if filteredNotifications.isEmpty {
                            VStack(spacing: 20) {
                                Spacer(minLength: 50)
                                Image(systemName: "bell.slash")
                                    .font(.system(size: 50))
                                    .foregroundColor(.gray.opacity(0.5))
                                Text(selectedTab == "All" ? "No new notifications" : "No new matches yet")
                                    .font(.headline)
                                    .foregroundColor(.gray)
                            }
                        } else {
                            ForEach(filteredNotifications) { notification in
                                NotificationRow(
                                    imageUrl: notification.senderImageUrl,
                                    text: notification.body
                                ) {
                                    notificationAction(for: notification)
                                }
                            }
                        }
                    }
                }
            }
            .background(AppTheme.backgroundPink)
            .onAppear {
                notificationsManager.clearUnreadCount()
                Task {
                    await notificationsManager.fetchHistoricalNotifications()
                }
            }
            .navigationDestination(for: DiscoverProfile.self) { profile in
                ProfileScreenView(path: $path, profile: profile, viewModel: discoverViewModel)
                    .toolbar(.hidden, for: .tabBar)
            }
            .navigationDestination(for: ChatRoute.self) { route in
                switch route {
                case .chat(let item):
                    ChatView(
                        conversationId: item.conversationId,
                        receiverId: item.profileId,
                        receiverName: item.userName,
                        receiverImageURL: item.profile
                    )
                    .toolbar(.hidden, for: .tabBar)
                case .profile(let profile):
                    ProfileScreenView(path: $path, profile: profile, viewModel: discoverViewModel)
                        .toolbar(.hidden, for: .tabBar)
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    
    @ViewBuilder
    private func notificationAction(for notification: AppNotification) -> some View {
        switch notification.notificationType {
        case "like":
            HStack(spacing: 10) {
                ActionButton(title: "Accept") {
                    Task {
                        await notificationsManager.acceptLikeRequest(notification: notification)
                    }
                }
                ActionButton(title: "Decline 🙊") {
                    Task {
                        await notificationsManager.declineLikeRequest(notification: notification)
                    }
                }
            }
        case "match":
            HStack(spacing: 11) {
                // View Profile action
                ActionButton(title: "View Profile 🫣") {
                    Task {
                        // De-clutter: Call delete notification first
                        await notificationsManager.deleteNotification(notificationId: notification.id)
                        
                        do {
                            let profileId = notification.targetUserId
                            let profile = try await notificationsManager.fetchProfileFromNotification(userId: profileId)
                            path.append(profile)
                        } catch {
                            print("❌ Failed to navigate to profile: \(error)")
                        }
                    }
                }
                
                // Send Message action via NavigationPath (ChatRoute)
                ActionButton(title: "Send Message 💬") {
                    Task {
                        // De-clutter: Call delete notification first
                        await notificationsManager.deleteNotification(notificationId: notification.id)
                        
                        let item = InboxItem(
                            conversationId: notification.conversationId ?? 0,
                            profileId: notification.targetUserId,
                            userName: notification.senderName,
                            firstName: "",
                            lastName: "",
                            lastMessage: "",
                            lastMessageTime: "",
                            profile: notification.senderImageUrl,
                            isBlocked: false,
                            unreadCount: 0
                        )
                        path.append(ChatRoute.chat(item))
                    }
                }
            }
        default:
            EmptyView()
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
    var action: (() -> Void)? = nil
    
    var body: some View {
        if let action = action {
            Button(action: action) {
                label
            }
        } else {
            label
        }
    }
    
    private var label: some View {
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
