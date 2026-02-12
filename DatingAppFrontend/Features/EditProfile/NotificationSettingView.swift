//
//  NotificationSettingView.swift
//  DatingAppFrontend
//
//  Created by Antigravity on 11/02/26.
//

import SwiftUI

struct NotificationSettingView: View {
    @Environment(\.dismiss) var dismiss
    
    // State for each notification toggle
    @State private var matchNotification = true
    @State private var messageNotification = true
    @State private var emailNotification = true
    @State private var smsNotification = false
    
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
                        isOn: $matchNotification
                    )
                    
                    NotificationToggleRow(
                        title: "Message Notification",
                        isOn: $messageNotification
                    )
                    
                    NotificationToggleRow(
                        title: "Email Notification",
                        isOn: $emailNotification
                    )
                    
                    NotificationToggleRow(
                        title: "SMS Notification",
                        isOn: $smsNotification
                    )
                }
                .padding(.horizontal)
                .padding(.top, 16)
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
}

// Reusable toggle row component
struct NotificationToggleRow: View {
    let title: String
    @Binding var isOn: Bool
    
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
        }
        .padding(.horizontal, 4)
    }
}

#Preview {
    NotificationSettingView()
}
