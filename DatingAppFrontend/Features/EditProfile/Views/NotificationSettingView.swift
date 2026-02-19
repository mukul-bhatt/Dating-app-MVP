//
//  NotificationSettingView.swift
//  DatingAppFrontend
//
//  Created by Antigravity on 11/02/26.
//

import SwiftUI

struct NotificationSettingView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        ZStack {
            AppTheme.backgroundPink.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 24) {
                // Header with back button
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                            .padding(12)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                    }
                    
                    Spacer()
                    
                    Text("Notifications")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    // Invisible spacer to center the title
                    Color.clear
                        .frame(width: 42, height: 42)
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                // Notification Settings List
                VStack(spacing: 16) {
                    NotificationToggleRow(
                        title: "Match Notification",
                        isOn: $viewModel.matchNotification,
                        viewModel: viewModel
                    )
                    
                    NotificationToggleRow(
                        title: "Message Notification",
                        isOn: $viewModel.messageNotification,
                        viewModel: viewModel
                    )
                    
                    NotificationToggleRow(
                        title: "Email Notification",
                        isOn: $viewModel.emailNotification,
                        viewModel: viewModel
                    )
                    
                    NotificationToggleRow(
                        title: "SMS Notification",
                        isOn: $viewModel.smsNotification,
                        viewModel: viewModel
                    )
                    
                    NotificationToggleRow(
                        title: "Like Notification",
                        isOn: $viewModel.likeNotification,
                        viewModel: viewModel
                    )
                }
                .padding(.horizontal)
                .padding(.top, 16)
                
                Spacer()
            }
            
            if viewModel.isUpdating {
                Color.black.opacity(0.1).ignoresSafeArea()
                ProgressView()
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchNotificationSettings()
            }
        }
        .navigationBarHidden(true)
        .overlay {
            if viewModel.isLoading {
                Color.black.opacity(0.1).ignoresSafeArea()
                ProgressView("Loading settings...")
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
        }
    }
}

// Reusable toggle row component
struct NotificationToggleRow: View {
    let title: String
    @Binding var isOn: Bool
    @ObservedObject var viewModel: SettingsViewModel
    
    var body: some View {
        HStack {
            Text(title)
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(.black)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(Color("ButtonColor"))
                .onChange(of: isOn) { oldValue, newValue in
                    let type = title.replacingOccurrences(of: " ", with: "")
                    Task {
                        await viewModel.updateNotificationSetting(type: type, show: newValue)
                    }
                }
                
        }
        .padding(.horizontal, 4)
    }
}

#Preview {
    NotificationSettingView()
}


// 7777766666

// delete acount
//{
//    "success": true
//}
