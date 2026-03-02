//
//  ChatView.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 04/02/26.
//

import SwiftUI
import PhotosUI

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
    @State private var isShowingDeleteChatConfirmation = false
    @State private var reportPath = NavigationPath()
    @StateObject var discoverViewModel = DiscoverViewModel()
    @StateObject private var typingViewModel: TypingViewModel

    init(conversationId: Int, receiverId: Int, receiverName: String?, receiverImageURL: URL?, initialMessage: String? = nil) {
        self.conversationId = conversationId
        self.receiverId = receiverId
        self.receiverName = receiverName
        self.receiverImageURL = receiverImageURL
        self.initialMessage = initialMessage
        self._typingViewModel = StateObject(wrappedValue: TypingViewModel(conversationId: conversationId, receiverId: receiverId))
    }


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
                                                    MessageBubble(message: message, isFromMe: message.toUserId == authViewModel.profileId)
                                                        .id("\(message.id)")
                                                }
                                            }
                                        }
                                        
                                        if viewModel.isReceiverTyping {
                                            TypingIndicatorView()
                                                .id("typing_indicator")
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
                        .onChange(of: viewModel.isReceiverTyping) { oldValue, newValue in
                            if newValue {
                                withAnimation {
                                    proxy.scrollTo("typing_indicator", anchor: .bottom)
                                }
                            }
                        }

                    }
                }
                
                
                // MARK: - Input Field / Blocked State
                if viewModel.isBlockedByMe {
                    blockedByMeView
                } else if viewModel.isBlockedByThem {
                    blockedByThemView
                } else {
                    inputArea
                }
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
            .onChange(of: viewModel.messageFieldValue) { oldValue, newValue in
                typingViewModel.handleTextChange(newValue)
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
                                    // No dismiss() here - stay in ChatView to show blocked UI
                                }
                            }
                        }
                    }
                )
            }

            if isShowingDeleteChatConfirmation {
                DeleteChatConfirmationView(
                    isPresented: $isShowingDeleteChatConfirmation,
                    onDelete: {
                        Task {
                            await viewModel.deleteChat()
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
                    withAnimation {
                        isShowingBlockPopup = true
                    }
                }
                Button("Report user") {
                    isShowingReport = true
                }
                Button("Delete chat") {
                    withAnimation {
                        isShowingDeleteChatConfirmation = true
                    }
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
        VStack(spacing: 0) {
            // Image Preview
            if let selectedImage = viewModel.selectedImage {
                HStack {
                    ZStack(alignment: .topTrailing) {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .cornerRadius(12)
                            .clipped()
                        
                        Button(action: {
                            viewModel.clearSelectedImage()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.white)
                                .background(Color.black.opacity(0.6))
                                .clipShape(Circle())
                        }
                        .offset(x: 10, y: -10)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            
            HStack {
                HStack {
                    Button(action:{}) {
                        Image(systemName: "face.smiling")
                            .foregroundColor(.primary)
                    }
                    
                    TextField("Type Something", text: $viewModel.messageFieldValue)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Image(systemName: "paperclip")
                        .rotationEffect(.degrees(-224))
                    
                    PhotosPicker(selection: $viewModel.selectedPhotoItem, matching: .images) {
                        Image(systemName: "camera")
                            .foregroundColor(.primary)
                    }
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
    
    // MARK: - Blocked States UI
    
    var blockedByMeView: some View {
        VStack(spacing: 16) {
            Divider()
            HStack(spacing: 20) {
                Button(action: {
                    Task {
                        await viewModel.deleteChat()
                    }
                }) {
                    Text("Delete Chat")
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(Color.white)
                        .cornerRadius(30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                }
                
                Button(action: {
                    Task {
                        await viewModel.unblockUser()
                    }
                }) {
                    Text("Unblock User")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(AppTheme.foregroundPink)
                        .cornerRadius(30)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .background(Color.white)
    }
    
    var blockedByThemView: some View {
        VStack(spacing: 0) {
            Divider()
            Text("You can no longer reply to this conversation, they unmatched you :(")
                .font(.system(size: 14))
                .foregroundColor(.black.opacity(0.6))
                .multilineTextAlignment(.center)
                .padding(.vertical, 30)
                .padding(.horizontal, 40)
                .frame(maxWidth: .infinity)
        }
        .background(Color.white)
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
                Text("Say Hi!")
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

            VStack(alignment: .trailing, spacing: 4) {
                if message.type == "image" {
                    VStack(alignment: .leading, spacing: 8) {
                        if let localImage = message.localImage {
                            Image(uiImage: localImage)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 250, maxHeight: 300)
                                .cornerRadius(12)
                        } else if let url = URL(string: message.content) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(width: 200, height: 200)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: 250, maxHeight: 300)
                                        .cornerRadius(12)
                                case .failure:
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                        .foregroundColor(.gray)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        } else {
                            Text(message.content)
                                .font(.body)
                        }
                        
                        // Caption
                        if !message.content.isEmpty && message.content != "Sent an image" && URL(string: message.content) == nil {
                            Text(message.content)
                                .font(.body)
                                .padding(.top, 4)
                        }
                    }
                    
                    HStack(spacing: 4) {
                        Spacer(minLength: 0)
                        timestampAndStatus
                    }
                    .padding(.top, 2)
                    
                } else {
                    HStack(alignment: .bottom, spacing: 8) {
                        Text(message.content)
                            .font(.body)
                        
                        timestampAndStatus
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isFromMe ? AppTheme.foregroundPink : AppTheme.backgroundPink)
            .foregroundColor(isFromMe ? .white : .primary)
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)

            if !isFromMe {
                Spacer(minLength: 60)
            }
        }
    }

    private var timestampAndStatus: some View {
        HStack(spacing: 4) {
            Text(helper.parseHistoricalDate(message.createdAt), style: .time)
                .font(.system(size: 10))
                .foregroundColor(isFromMe ? .white.opacity(0.5) : .primary.opacity(0.7))
            
            if isFromMe {
                if message.status == "sending" {
                    Image(systemName: "clock")
                        .font(.system(size: 8))
                        .foregroundColor(.white.opacity(0.5))
                } else if message.status == "sent" || message.status == "delivered" {
                    Image(systemName: "checkmark")
                        .font(.system(size: 8))
                        .foregroundColor(.white.opacity(0.5))
                }
            }
        }
    }
}

//#Preview {
//    ChatView(conversationId: 1222, receiverId: 6002, receiverName: "Nia Sharma", receiverImageURL: URL(string: "https://images.pexels.com/photos/2238433/pexels-photo-2238433.jpeg"))
//}
