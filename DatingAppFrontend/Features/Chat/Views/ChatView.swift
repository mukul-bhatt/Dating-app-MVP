//
//  ChatView.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 04/02/26.
//

import SwiftUI

struct ChatView: View {
    
    @StateObject var viewModel = ChatViewModel()
    
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Custom Header
            headerView
            
            // MARK: - Chat Bubble List
            ScrollViewReader { proxy in
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        ForEach(viewModel.messages) { message in
                            MessageBubble(message: message)
                                .id(message.id)
                        }
                    }
                    .padding()
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
            
            
            // MARK: - Input Field
            inputArea
        }
        .onAppear{
            // 1. Setup Callbacks
            ChatSocketManager.shared.onChatMessageReceived = { message in
                viewModel.handleIncomingChatMessage(message)
            }
            
            ChatSocketManager.shared.onNotificationReceived = { notification in
                viewModel.handleIncomingNotification(notification)
            }
            
            
            // 2. Connect
            ChatSocketManager.shared.connect()
        }
    }
    
    // Header View with Profile Info
    var headerView: some View {
        
        let imageUrl = URL(string: "https://images.pexels.com/photos/2238433/pexels-photo-2238433.jpeg")
        
        return HStack(spacing: 15) {
            Image(systemName: "arrow.left")
            
            
            AsyncImage(url: imageUrl){ image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 45, height: 45)
                    .cornerRadius(50)
            }placeholder: {
                ProgressView()
            }

            
            Text("Nia Sharma")
                .font(.headline)
            
            Spacer()
            
            Image(systemName: "video.fill")
            Image(systemName: "phone.fill")
            
            Menu {
                Button("Block user") {
                    // Block action
                }
                Button("Report user") {
                    // Report action
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

struct MessageBubble: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.isFromMe { Spacer(minLength: 50) }
            
            Text(message.text)
                .padding(14)
                .background(message.isFromMe ? AppTheme.backgroundPink : AppTheme.foregroundPink)
                .foregroundColor(message.isFromMe ? .primary : .white)
                .cornerRadius(15)
            
            if !message.isFromMe { Spacer(minLength: 50) }
        }
    }
}



#Preview {
    ChatView()
}
