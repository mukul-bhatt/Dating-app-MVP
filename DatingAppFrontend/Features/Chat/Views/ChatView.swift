//
//  ChatView.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 04/02/26.
//

import SwiftUI

struct ChatView: View {
    
    @StateObject var viewModel = ChatViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var notificationsManager: NotificationsManager
    @Environment(\.dismiss) var dismiss
    
    let conversationId: Int
    let receiverId: Int
    let receiverName: String?
    let receiverImageURL: URL?
    var initialMessage: String? = nil
    
    @State private var isShowingReport = false
    @State private var isShowingBlockPopup = false
    @State private var reportPath = NavigationPath()
    @StateObject var discoverViewModel = DiscoverViewModel()

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // MARK: - Custom Header
                headerView
                
                // MARK: - Chat Bubble List
                GeometryReader { geometry in
                    ScrollViewReader { proxy in
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 0) {
                                if viewModel.groupedMessages.isEmpty {
                                    Spacer(minLength: 120)
                                    SayHiView(viewModel: viewModel)
                                    Spacer()
                                } else {
                                    // This Spacer forces the messages to the bottom
                                    Spacer(minLength: 0)
                                    
                                    VStack(spacing: 24) {
                                        ForEach(viewModel.groupedMessages) { group in
                                            VStack(spacing: 16) {
                                                // Date Header
                                                DateHeaderView(date: group.dateGroup)
                                                
                                                ForEach(group.messages) { message in
                                                    MessageBubble(message: message, isFromMe: message.toUserId == receiverId)
                                                        .id("\(message.id)")
                                                }
                                            }
                                        }
                                    }
                                    .padding()
                                }
                            }
                            .frame(minWidth: geometry.size.width, minHeight: geometry.size.height)
                        }
                        .background(Color.white)
                        .onChange(of: viewModel.lastMessageId) { oldValue, newValue in
                            if let newValue = newValue {
                                withAnimation {
                                    proxy.scrollTo(newValue, anchor: .bottom)
                                }
                            }
                        }
                    }
                }
                
                
                // MARK: - Input Field
                inputArea
            }
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .tabBar)
            .onAppear{
                print("👁️ ChatView appeared for convId: \(conversationId)")
                // Connect using the current user's profileId and passed receiver info
                if let myId = authViewModel.profileId {
                    viewModel.connect(
                        userId: myId, 
                        conversationId: conversationId, 
                        receiverId: receiverId, 
                        name: receiverName, 
                        imageURL: receiverImageURL,
                        initialMessage: initialMessage,
                        notificationsManager: notificationsManager
                    )
                } else {
                    print("⚠️ authViewModel.profileId is missing in ChatView")
                }
                // Track focus for global notifications
                notificationsManager.activeConversationId = conversationId
                notificationsManager.activeReceiverId = receiverId
            }
            .onDisappear {
                // Clear focus
                notificationsManager.activeConversationId = nil
                notificationsManager.activeReceiverId = nil
            }
            .fullScreenCover(isPresented: $isShowingReport) {
                NavigationStack(path: $reportPath) {
                    ReportProfileView(
                        path: $reportPath,
                        profileId: receiverId,
                        viewModel: discoverViewModel
                    )
                    .navigationDestination(for: DiscoverRoute.self) { route in
                        switch route {
                        case .Submit:
                            SettingUpScreen(title: "Report Submitted", subTitle: "Thanks for reporting. Our Team will review this profile shortly")
                                .toolbar(.hidden, for: .tabBar)
                        default:
                            EmptyView()
                        }
                    }
                }
            }
            
            if isShowingBlockPopup {
                BlockUserView(
                    userName: viewModel.receiverName,
                    isPresented: $isShowingBlockPopup,
                    onBlock: { report in
                        Task {
                            let success = await viewModel.blockUser(status: "Blocked")
                            if success {
                                await MainActor.run {
                                    isShowingBlockPopup = false
                                    dismiss() // Navigate back to inbox after blocking
                                }
                            }
                        }
                    }
                )
            }
        }
    }
    
    // Header View with Profile Info
    var headerView: some View {
        
        HStack(spacing: 15) {
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "arrow.left")
            }
            
            
            AsyncImage(url: viewModel.receiverImageURL){ image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 45, height: 45)
                    .clipShape(Circle())
            }placeholder: {
                Circle()
                    .frame(width: 45, height: 45)
                    .foregroundColor(.gray.opacity(0.3))
            }

            
            Text(viewModel.receiverName)
                .font(.headline)
            
            Spacer()
            
            Image(systemName: "video.fill")
            Image(systemName: "phone.fill")
            
            Menu {
                Button("Block user") {
                    isShowingBlockPopup = true
                }
                Button("Report user") {
                    isShowingReport = true
                }
            } label: {
                Image(systemName: "ellipsis")
                    .rotationEffect(.degrees(90))
            }
        }
        .padding()
        .foregroundColor(.white)
        .background(AppTheme.foregroundPink)
    }
    
    // Bottom Input Bar
    var inputArea: some View {
        
            HStack {
                HStack {
                    
                    Button(action:{}) {
                        Image(systemName: "face.smiling")
                            .foregroundColor(.primary)
                    }
                    
                    
                    TextField("Type Something", text: $viewModel.messageFieldValue)
                        .foregroundColor(.gray)
                    Spacer()
                    Image(systemName: "paperclip").rotationEffect(.degrees(-224))
                    Image(systemName: "camera")
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(AppTheme.backgroundPink)
                .cornerRadius(25)
            
            Button(action: {
                viewModel.sendMessage()
            }) {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.black.opacity(0.7))
                    .padding(12)
                    .background(AppTheme.backgroundPink)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 1))
            }
        }
        .padding()
    }
}

struct DateHeaderView: View {
    let date: String
    
    var body: some View {
        Text(date)
            .font(.system(size: 12, weight: .medium))
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            .foregroundColor(.gray)
            .padding(.vertical, 8)
    }
}

struct SayHiView: View {
    @ObservedObject var viewModel: ChatViewModel
    
    var body: some View {
        VStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(AppTheme.backgroundPink)
                    .frame(width: 100, height: 100)
                
                Text("👋")
                    .font(.system(size: 50))
            }
            
            VStack(spacing: 8) {
                Text("No messages yet")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("Start the conversation by saying Hi!")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
            
            Button(action: {
                viewModel.sendGreeting()
            }) {
                Text("Say Hi! 👋")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .background(AppTheme.foregroundPink)
                    .cornerRadius(25)
                    .shadow(color: AppTheme.foregroundPink.opacity(0.3), radius: 5, x: 0, y: 5)
            }
            .padding(.top, 10)
        }
    }
}



struct MessageBubble: View {
    let message: ChatMessage
    let isFromMe: Bool
    @StateObject private var helper = ChatViewModel() // For parsing dates

    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            if isFromMe {
                Spacer(minLength: 60)
            }

            HStack {
                Text(message.content)
                    .font(.body)
                    
                Text(helper.parseHistoricalDate(message.createdAt), style: .time)
                    .padding(.top, 8)
                    .font(.system(size: 10))
                    .foregroundColor(isFromMe ? .primary.opacity(0.5) : .white.opacity(0.7))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isFromMe ? AppTheme.backgroundPink : AppTheme.foregroundPink)
            .foregroundColor(isFromMe ? .primary : .white)
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)

            if !isFromMe {
                Spacer(minLength: 60)
            }
        }
    }
}

//#Preview {
//    ChatView(conversationId: 1222, receiverId: 6002, receiverName: "Nia Sharma", receiverImageURL: URL(string: "https://images.pexels.com/photos/2238433/pexels-photo-2238433.jpeg"))
//}
