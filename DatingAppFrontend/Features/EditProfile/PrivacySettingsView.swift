//
//  PrivacySettingsView.swift
//  DatingAppFrontend
//
//  Created by Antigravity on 11/02/26.
//

import SwiftUI

struct PrivacySettingsView: View {
    @Environment(\.dismiss) var dismiss
    
    // State for each privacy setting
    @State private var displayFullName = "Everyone"
    @State private var displayAge = "Only my Matches"
    @State private var displayLocation = "Everyone"
    @State private var whoCanSeeYou = "Everyone"
    @State private var activityStatus = "Choose an option"
    
    // Dropdown options
    let privacyOptions = ["Everyone", "Only my Matches", "Nobody"]
    let activityOptions = ["Everyone", "Only my matches", "Nobody"]
    
    var body: some View {
        ZStack {
            AppTheme.backgroundPink.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
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
                    
                    Text("Privacy Settings")
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
                .padding(.bottom, 24)
                
                // Privacy Settings List
                VStack(spacing: 0) {
                    PrivacySettingRow(
                        title: "Display Full name",
                        selectedOption: $displayFullName,
                        options: privacyOptions
                    )
                    
                    Divider()
                        .background(Color.white.opacity(0.3))
                    
                    PrivacySettingRow(
                        title: "Display Age",
                        selectedOption: $displayAge,
                        options: privacyOptions
                    )
                    
                    Divider()
                        .background(Color.white.opacity(0.3))
                    
                    PrivacySettingRow(
                        title: "Display Location",
                        selectedOption: $displayLocation,
                        options: privacyOptions
                    )
                    
                    Divider()
                        .background(Color.white.opacity(0.3))
                    
                    PrivacySettingRow(
                        title: "Who can see you",
                        selectedOption: $whoCanSeeYou,
                        options: privacyOptions
                    )
                    
                    Divider()
                        .background(Color.white.opacity(0.3))
                    
                    PrivacySettingRow(
                        title: "Activity Status",
                        selectedOption: $activityStatus,
                        options: activityOptions
                    )
                }
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
}

// Reusable privacy setting row with dropdown
struct PrivacySettingRow: View {
    let title: String
    @Binding var selectedOption: String
    let options: [String]
    
    var body: some View {
        Menu {
            ForEach(options, id: \.self) { option in
                Button(action: {
                    selectedOption = option
                }) {
                    HStack {
                        Text(option)
                        if selectedOption == option {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            HStack {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.black)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Text(selectedOption)
                        .font(.subheadline)
                        .foregroundColor(.black.opacity(0.7))
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12))
                        .foregroundColor(.black.opacity(0.7))
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 16)
            .background(Color.clear)
        }
    }
}

#Preview {
    PrivacySettingsView()
}
