//
//  PrivacySettingsView.swift
//  DatingAppFrontend
//
//  Created by Antigravity on 11/02/26.
//

import SwiftUI


struct PrivacySettingsView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = SettingsViewModel()
    
    // Dropdown options
    let privacyOptions = ["Everyone", "Only my Matches", "Nobody"]
    let activityOptions = ["Everyone", "Only my Matches", "Nobody"]
    
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
                        selectedOption: $viewModel.displayFullName,
                        options: privacyOptions,
                        viewModel: viewModel
                    )
                    
                    Divider()
                        .background(Color.white.opacity(0.3))
                    
                    PrivacySettingRow(
                        title: "Display Age",
                        selectedOption: $viewModel.displayAge,
                        options: privacyOptions,
                        viewModel: viewModel
                    )
                    
                    Divider()
                        .background(Color.white.opacity(0.3))
                    
                    PrivacySettingRow(
                        title: "Display Location",
                        selectedOption: $viewModel.displayLocation,
                        options: privacyOptions,
                        viewModel: viewModel
                    )
                    
                    Divider()
                        .background(Color.white.opacity(0.3))
                    
                    PrivacySettingRow(
                        title: "Who can see you",
                        selectedOption: $viewModel.whoCanSeeYou,
                        options: privacyOptions,
                        viewModel: viewModel
                    )
                    
                    Divider()
                        .background(Color.white.opacity(0.3))
                    
                    PrivacySettingRow(
                        title: "Activity Status",
                        selectedOption: $viewModel.activityStatus,
                        options: activityOptions,
                        viewModel: viewModel
                    )
                }
                
                Spacer()
            }
            
            if viewModel.isLoading || viewModel.isUpdating {
                Color.black.opacity(0.1).ignoresSafeArea()
                ProgressView(viewModel.isLoading ? "Loading settings..." : "Updating...")
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchPrivacySettings()
            }
        }
        .alert("Update Failed", isPresented: $viewModel.showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage ?? "An unknown error occurred.")
        }
        .navigationBarHidden(true)
    }
}

// Reusable privacy setting row with dropdown
struct PrivacySettingRow: View {
    let title: String
    @Binding var selectedOption: String
    let options: [String]
    @ObservedObject var viewModel: SettingsViewModel
    
    var body: some View {
        Menu {
            ForEach(options, id: \.self) { option in
                Button(action: {
                    selectedOption = option
                    Task {
                        await viewModel.updatePrivacySettings()
                    }
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
