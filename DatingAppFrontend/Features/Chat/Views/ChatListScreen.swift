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
    
    var body: some View {
        NavigationStack {
            ZStack{
                
                AppTheme.backgroundPink.ignoresSafeArea()
                
                VStack{
                    // MARK: - Header
                    headerView
                    // Spacer()
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Online")
                            .font(.headline)
                            .padding(.horizontal)
                            .padding(.top)
                        
                        // MARK: - Online Stories Row
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(viewModel.onlineUsers) { user in
                                    NavigationLink {
                                        ChatView(conversationId: 0, receiverId: user.userId, receiverName: user.name, receiverImageURL: user.profileImage)
                                    } label: {
                                        OnlineCircleView(user: user)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        ScrollView {
                            // MARK: - Chat List
                            VStack(spacing: 0) {
                                ForEach(viewModel.inboxItems) { inboxItem in
                                    NavigationLink {
                                        ChatView(
                                            conversationId: inboxItem.conversationId,
                                            receiverId: inboxItem.profileId,
                                            receiverName: inboxItem.userName,
                                            receiverImageURL: inboxItem.profile
                                        )
                                    } label: {
                                        ChatRowView(item: inboxItem)
                                    }
                                    
                                    Divider()
                                        .padding(.leading, 80)
                                        .padding(.trailing)
                                }
                            }
                        }
                        .refreshable {
                            viewModel.fetchInbox()
                        }
                        
                    }
                }
            }
        }
        .onAppear {
            viewModel.notificationsManager = notificationsManager
            
            if let myId = authViewModel.profileId {
                ChatSocketManager.shared.connect(userId: myId)
            }
            
            viewModel.fetchInbox()
            
        }
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
        .background(AppTheme.foregroundPink)
    }
    
}

// MARK: - Subviews

struct OnlineCircleView: View {
    let user: MatchStatusUser
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            AsyncImage(url: user.profileImage) { image in
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
    
    var body: some View {
        HStack(spacing: 15) {
            AsyncImage(url: item.profile) { image in
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
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.userName)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.primary)
                Text(item.lastMessage)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Text(item.lastMessageTime)
                .font(.system(size: 12))
                .foregroundColor(.secondary)
        }
        .padding()
    }
}


#Preview{
    ChatListScreen()
}
