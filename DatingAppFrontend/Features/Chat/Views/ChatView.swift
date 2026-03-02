//
//  ChatView.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 04/02/26.
//

import SwiftUI
import PhotosUI
import UniformTypeIdentifiers

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
    @State private var isShowingDeleteMessageConfirmation = false
    @State private var messageToDelete: ChatMessage? = nil
    @State private var isShowingDocumentPicker = false
    @State private var reportPath = NavigationPath()
    // Multi-select
    @State private var isSelectMode: Bool = false
    @State private var selectedMessageIds: Set<Int> = []
    @State private var bulkDeleteIds: [Int] = []
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
                                                    let isFromMe = message.toUserId == authViewModel.profileId
                                                    let isSelected = selectedMessageIds.contains(message.id)

                                                    HStack(spacing: 10) {
                                                        // Checkbox (only visible in select mode)
                                                        if isSelectMode {
                                                            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                                                                .foregroundColor(isSelected ? AppTheme.foregroundPink : .gray.opacity(0.5))
                                                                .font(.system(size: 22))
                                                                .transition(.scale.combined(with: .opacity))
                                                        }

                                                        MessageBubble(message: message, isFromMe: isFromMe)
                                                            .id("\(message.id)")
                                                            .contextMenu {
                                                                if isFromMe {
                                                                    Button(role: .destructive) {
                                                                        messageToDelete = message
                                                                        withAnimation {
                                                                            isShowingDeleteMessageConfirmation = true
                                                                        }
                                                                    } label: {
                                                                        Label("Delete Message", systemImage: "trash")
                                                                    }
                                                                }
                                                                Button {
                                                                    withAnimation {
                                                                        isSelectMode = true
                                                                        selectedMessageIds.insert(message.id)
                                                                    }
                                                                } label: {
                                                                    Label("Select Messages", systemImage: "checkmark.circle")
                                                                }
                                                            }
                                                    }
                                                    .contentShape(Rectangle())
                                                    .onTapGesture {
                                                        if isSelectMode {
                                                            withAnimation(.spring(response: 0.25)) {
                                                                if isSelected {
                                                                    selectedMessageIds.remove(message.id)
                                                                } else {
                                                                    selectedMessageIds.insert(message.id)
                                                                }
                                                            }
                                                        }
                                                    }
                                                    .background(
                                                        isSelected
                                                            ? AppTheme.foregroundPink.opacity(0.08)
                                                            : Color.clear
                                                    )
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
                if isSelectMode {
                    multiSelectToolbar
                } else if viewModel.isBlockedByMe {
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
            .fileImporter(
                isPresented: $isShowingDocumentPicker,
                allowedContentTypes: [.pdf, .text, .data, .item],
                allowsMultipleSelection: false
            ) { result in
                switch result {
                case .success(let urls):
                    guard let url = urls.first else { return }
                    viewModel.selectedDocumentURL = url
                    viewModel.selectedDocumentName = url.lastPathComponent
                case .failure(let error):
                    print("❌ Document pick error: \(error.localizedDescription)")
                }
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

            if isShowingDeleteMessageConfirmation {
                DeleteMessageConfirmationView(
                    isPresented: $isShowingDeleteMessageConfirmation,
                    onDelete: {
                        let ids: [Int] = bulkDeleteIds.isEmpty
                            ? (messageToDelete.map { [$0.id] } ?? [])
                            : bulkDeleteIds
                        Task {
                            await viewModel.deleteMessages(messageIds: ids)
                            await MainActor.run {
                                if !bulkDeleteIds.isEmpty {
                                    // Exit select mode after bulk delete
                                    isSelectMode = false
                                    selectedMessageIds = []
                                    bulkDeleteIds = []
                                }
                                messageToDelete = nil
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
            
            // Document Preview
            if let docName = viewModel.selectedDocumentName {
                HStack(spacing: 10) {
                    Image(systemName: "doc.fill")
                        .foregroundColor(AppTheme.foregroundPink)
                        .font(.title2)
                    
                    Text(docName)
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                        .truncationMode(.middle)
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.clearSelectedDocument()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(AppTheme.backgroundPink)
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.bottom, 6)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            
            HStack {
                HStack {
                    Button(action:{}) {
                        Image(systemName: "face.smiling")
                            .foregroundColor(.primary)
                            .opacity(0)
                    }
                    
                    TextField("Type Something", text: $viewModel.messageFieldValue)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    // Paperclip → Document Picker
                    Button(action: {
                        isShowingDocumentPicker = true
                    }) {
                        Image(systemName: "paperclip")
                            .rotationEffect(.degrees(-224))
                            .foregroundColor(.primary)
                    }
                    
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
                    if viewModel.selectedDocumentURL != nil {
                        viewModel.sendDocument()
                    } else {
                        viewModel.sendMessage()
                    }
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
    
    // MARK: - Multi-Select Toolbar
    
    var multiSelectToolbar: some View {
        VStack(spacing: 0) {
            Divider()
            HStack(spacing: 16) {
                // Cancel
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isSelectMode = false
                        selectedMessageIds = []
                    }
                }) {
                    Text("Cancel")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(Color.white)
                        .cornerRadius(30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                }

                // Delete Selected
                Button(action: {
                    let ids = Array(selectedMessageIds)
                    withAnimation {
                        isShowingDeleteMessageConfirmation = true
                        // Store IDs in messageToDelete via a dummy approach — we'll
                        // pass directly using the confirmation closure capture below.
                    }
                    // We use a separate state to hold the bulk ids
                    bulkDeleteIds = ids
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "trash")
                        Text(selectedMessageIds.isEmpty ? "Delete" : "Delete (\(selectedMessageIds.count))")
                    }
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(selectedMessageIds.isEmpty ? .gray : .white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(selectedMessageIds.isEmpty ? Color.gray.opacity(0.15) : AppTheme.foregroundPink)
                    .cornerRadius(30)
                }
                .disabled(selectedMessageIds.isEmpty)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
            .padding(.top, 12)
        }
        .background(Color.white)
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



struct TextMessageBubble: View {
    let message: ChatMessage
    let isFromMe: Bool
    let time: String
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            Text(message.content)
                .font(.body)
            
            HStack(spacing: 4) {
                Text(time)
                    .font(.system(size: 10))
                    .foregroundColor(isFromMe ? .white.opacity(0.7) : .primary.opacity(0.5))
                
                if isFromMe {
                    statusIcon
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(isFromMe ? AppTheme.foregroundPink : AppTheme.backgroundPink)
        .foregroundColor(isFromMe ? .white : .primary)
        .cornerRadius(15)
    }
    
    @ViewBuilder
    private var statusIcon: some View {
        if message.status == "sending" {
            Image(systemName: "clock")
                .font(.system(size: 8))
                .foregroundColor(.white.opacity(0.7))
        } else if message.status == "sent" || message.status == "delivered" {
            Image(systemName: "checkmark")
                .font(.system(size: 8))
                .foregroundColor(.white.opacity(0.7))
        }
    }
}

struct ImageMessageBubble: View {
    let message: ChatMessage
    let isFromMe: Bool
    let time: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .bottomTrailing) {
                // Image
                if let localImage = message.localImage {
                    Image(uiImage: localImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 250, maxHeight: 300)
                } else if let imageUrl = message.image ?? (message.content.hasPrefix("http") ? message.content : nil),
                          let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: 200, height: 200)
                                .padding()
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 250, maxHeight: 300)
                        case .failure:
                            VStack {
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.gray)
                                Text("Failed to load")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }
                            .frame(width: 200, height: 200)
                            .padding()
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
                
                // Timestamp Overlay
                if !hasCaption {
                    HStack(spacing: 4) {
                        Text(time)
                            .font(.system(size: 10))
                            .foregroundColor(.white)
                        
                        if isFromMe {
                            statusIcon
                        }
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(10)
                    .padding(8)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 15))
            
            // Caption
            if hasCaption {
                VStack(alignment: .leading, spacing: 4) {
                    Text(message.content)
                        .font(.body)
                    
                    HStack {
                        Spacer()
                        HStack(spacing: 4) {
                            Text(time)
                                .font(.system(size: 10))
                                .foregroundColor(isFromMe ? .white.opacity(0.7) : .primary.opacity(0.5))
                            
                            if isFromMe {
                                statusIcon
                            }
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.top, 8)
                .padding(.bottom, 8)
            }
        }
        .background(isFromMe ? AppTheme.foregroundPink : AppTheme.backgroundPink)
        .foregroundColor(isFromMe ? .white : .primary)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
    
    private var hasCaption: Bool {
        !message.content.isEmpty && message.content != "Sent an image" && !message.content.hasPrefix("http")
    }
    
    @ViewBuilder
    private var statusIcon: some View {
        if message.status == "sending" {
            Image(systemName: "clock")
                .font(.system(size: 8))
                .foregroundColor(hasCaption ? (isFromMe ? .white.opacity(0.7) : .primary.opacity(0.5)) : .white)
        } else if message.status == "sent" || message.status == "delivered" {
            Image(systemName: "checkmark")
                .font(.system(size: 8))
                .foregroundColor(hasCaption ? (isFromMe ? .white.opacity(0.7) : .primary.opacity(0.5)) : .white)
        }
    }
}

struct DocumentMessageBubble: View {
    let message: ChatMessage
    let isFromMe: Bool
    let time: String
    
    private var iconName: String {
        let ext = (message.content as NSString).pathExtension.lowercased()
        switch ext {
        case "pdf": return "doc.richtext.fill"
        case "doc", "docx": return "doc.text.fill"
        case "xls", "xlsx": return "tablecells.fill"
        case "txt": return "doc.plaintext.fill"
        default: return "doc.fill"
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: iconName)
                .font(.title2)
                .foregroundColor(isFromMe ? .white : AppTheme.foregroundPink)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(message.content)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(2)
                
                HStack(spacing: 4) {
                    Text(time)
                        .font(.system(size: 10))
                        .foregroundColor(isFromMe ? .white.opacity(0.7) : .primary.opacity(0.5))
                    
                    if isFromMe { statusIcon }
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(isFromMe ? AppTheme.foregroundPink : AppTheme.backgroundPink)
        .foregroundColor(isFromMe ? .white : .primary)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
    
    @ViewBuilder
    private var statusIcon: some View {
        if message.status == "sending" {
            Image(systemName: "clock")
                .font(.system(size: 8))
                .foregroundColor(.white.opacity(0.7))
        } else if message.status == "sent" || message.status == "delivered" {
            Image(systemName: "checkmark")
                .font(.system(size: 8))
                .foregroundColor(.white.opacity(0.7))
        }
    }
}

struct MessageBubble: View {
    let message: ChatMessage
    let isFromMe: Bool
    @StateObject private var helper = ChatViewModel()

    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            if isFromMe {
                Spacer(minLength: 60)
            }

            let timeString = formatTime(message.createdAt)
            
            if message.type == "image" {
                ImageMessageBubble(message: message, isFromMe: isFromMe, time: timeString)
            } else if message.type == "document" {
                DocumentMessageBubble(message: message, isFromMe: isFromMe, time: timeString)
            } else {
                TextMessageBubble(message: message, isFromMe: isFromMe, time: timeString)
            }

            if !isFromMe {
                Spacer(minLength: 60)
            }
        }
        .padding(.vertical, 4)
    }

    private func formatTime(_ dateString: String) -> String {
        let date = helper.parseHistoricalDate(dateString)
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
}

//#Preview {
//    ChatView(conversationId: 1222, receiverId: 6002, receiverName: "Nia Sharma", receiverImageURL: URL(string: "https://images.pexels.com/photos/2238433/pexels-photo-2238433.jpeg"))
