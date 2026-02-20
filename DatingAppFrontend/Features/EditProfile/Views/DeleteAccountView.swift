//
//  DeleteAccountView.swift
//  DatingAppFrontend
//
//  Created by Antigravity on 11/02/26.
//

import SwiftUI

struct DeleteAccountView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var viewModel = SettingsViewModel()
    
    @State private var selectedReason: String = "Privacy concerns"
    @State private var showDeleteConfirmation: Bool = false
    
    let deletionReasons = [
        "Privacy concerns",
        "Found someone",
        "Not getting matches",
        "Technical issues",
        "Other"
    ]
    
    var body: some View {
        ZStack {
            AppTheme.backgroundPink.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 32) {
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
                    
                    Text("Delete Account")
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
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Select reason for deletion of account")
                        .font(.body)
                        .foregroundColor(.black)
                    
                    // Reason Dropdown
                    Menu {
                        ForEach(deletionReasons, id: \.self) { reason in
                            Button(action: {
                                selectedReason = reason
                            }) {
                                Text(reason)
                            }
                        }
                    } label: {
                        HStack {
                            Text(selectedReason)
                                .foregroundColor(.black)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .font(.system(size: 14))
                                .foregroundColor(.black)
                        }
                        .padding()
                        .background(Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                        )
                    }
                    
                    // Delete Button
                    Button(action: {
                        withAnimation {
                            showDeleteConfirmation = true
                        }
                    }) {
                        Text("Delete Account")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(AppTheme.foregroundPink)
                            .cornerRadius(28)
                    }
                    .padding(.top, 16)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .blur(radius: viewModel.isUpdating ? 3 : 0)
            .disabled(viewModel.isUpdating)
            
            if showDeleteConfirmation {
                DeleteConfirmationView(showDeleteConfirmation: $showDeleteConfirmation, onDelete: {
                    Task {
                        let success = await viewModel.deleteAccount(reason: selectedReason)
                        if success {
                            authViewModel.logout()
                        }
                        showDeleteConfirmation = false
                    }
                })
            }
            
            // Loading Overlay
            if viewModel.isUpdating {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    ProgressView()
                        .scaleEffect(1.5)
                        .tint(.white)
                    Text("Deleting Account...")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                .padding(32)
                .background(Color.black.opacity(0.7))
                .cornerRadius(16)
            }
        }
        .alert("Error", isPresented: $viewModel.showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage ?? "An unknown error occurred")
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    DeleteAccountView()
}
