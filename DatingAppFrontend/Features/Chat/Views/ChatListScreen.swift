//
//  ChatListScreen.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 04/02/26.
//


import SwiftUI

struct ChatListScreen: View {
    @StateObject var viewModel = ChatListViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var notificationsManager: NotificationsManager
    @Binding var path: NavigationPath
    
    var body: some View {
        ZStack{
            AppTheme.backgroundPink.ignoresSafeArea()
            
            VStack{
                // MARK: - Header
                headerView
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("Online")
                        .font(.headline)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    // MARK: - Online Stories Row
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(viewModel.onlineUsers) { user in
                                OnlineCircleView(user: user)
                                    .onTapGesture {
                                        Task {
                                            if let profile = await viewModel.fetchFullProfile(profileId: user.userId) {
                                                path.append(ChatRoute.profile(profile))
                                            }
                                        }
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    ScrollView {
                        // MARK: - Chat List
                        VStack(spacing: 0) {
                            ForEach(viewModel.inboxItems) { inboxItem in
                                ChatRowView(item: inboxItem, path: $path, viewModel: viewModel)
                                
                                Divider()
                                    .padding(.leading, 80)
                                    .padding(.trailing)
                            }
                        }
                    }
                    .refreshable {
                        viewModel.fetchInbox()
                        viewModel.fetchOnlineUsers()
                    }
                }
            }
        }
        // Overlay for profile fetching spinner
        .overlay(
            Group {
                if viewModel.isFetchingProfile {
                    ZStack {
                        Color.white.opacity(0.4)
                            .ignoresSafeArea()
                        
                        ProgressView()
                            .padding(20)
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.1), radius: 10)
                    }
                }
            }
        )
        .onAppear {
            viewModel.notificationsManager = notificationsManager
            
            viewModel.fetchInbox()
            viewModel.fetchOnlineUsers()
        }
    }
    
    var headerView: some View {
        HStack {
//            Image(systemName: "arrow.left")
            
            Text("Chats")
                .font(.title3)
                .fontWeight(.medium)
            Spacer()
        }
        .padding()
        .foregroundColor(.white)
        .background(AppTheme.foregroundPink)
    }
    
}

// MARK: - Subviews

struct OnlineCircleView: View {
    let user: MatchStatusUser
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            AsyncImage(url: user.profileImageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 65, height: 65)
                    .clipShape(Circle())
            } placeholder: {
                Circle()
                    .frame(width: 65, height: 65)
                    .foregroundColor(.gray.opacity(0.3))
            }
            
            if user.isOnline {
                Circle()
                    .frame(width: 14, height: 14)
                    .foregroundColor(.green)
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
            }
        }
    }
}

struct ChatRowView: View {
    let item: InboxItem
    @Binding var path: NavigationPath
    @ObservedObject var viewModel: ChatListViewModel
    
    var body: some View {
        HStack(spacing: 15) {
            // Avatar with Tap Gesture to view profile
            AsyncImage(url: item.profilePictureURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 55, height: 55)
                    .clipShape(Circle())
            } placeholder: {
                Circle()
                    .frame(width: 55, height: 55)
                    .foregroundColor(.gray.opacity(0.3))
            }
            .onTapGesture {
                Task {
                    if let profile = await viewModel.fetchFullProfile(profileId: item.profileId) {
                        path.append(ChatRoute.profile(profile))
                    }
                }
            }
            
            // Content with Tap Gesture to open chat
            VStack(alignment: .leading, spacing: 4) {
                Text(item.userName)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.primary)
                Text(item.lastMessage)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            .onTapGesture {
                path.append(ChatRoute.chat(item))
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 5) {
                Text(item.lastMessageTime)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                
                if item.unreadCount > 0 {
                    Text("\(item.unreadCount)")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                        .padding(6)
                        .background(AppTheme.foregroundPink)
                        .clipShape(Circle())
                }
            }
        }
        .padding()
    }
}


#Preview{
    ChatListScreen(path: .constant(NavigationPath()))
}
