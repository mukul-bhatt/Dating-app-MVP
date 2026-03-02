//
//  ContactDetailsView.swift
//  DatingAppFrontend
//
//  Created by Antigravity on 11/02/26.
//

import SwiftUI

struct ContactDetailsView: View {
    @StateObject private var settingsViewModel = SettingsViewModel()
    @Environment(\.dismiss) var dismiss
    
    @State private var hasClickedChangePhoneNumber = false
    @State private var enteredOtp: [String] = Array(repeating: "", count: 4)
    @State private var phoneNumberError: String? = nil
    
    // Validation function
    private func validatePhoneNumber() -> Bool {
        // Remove any whitespace
        let trimmedPhone = settingsViewModel.phoneNumber.trimmingCharacters(in: .whitespaces)
        
        // Check if it's numeric
        guard trimmedPhone.allSatisfy({ $0.isNumber }) else {
            phoneNumberError = "Phone number must contain only digits"
            return false
        }
        
        // Check if it's exactly 10 digits
        guard trimmedPhone.count == 10 else {
            phoneNumberError = "Phone number must be exactly 10 digits"
            return false
        }
        
        phoneNumberError = nil
        return true
    }
    
    var body: some View {
        ZStack {
            AppTheme.backgroundPink.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header with back button - ALWAYS INTERACTIVE
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
                    
                    Text("Contact Details")
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
                
                // Content Area with its own overlay
                ZStack {
                    VStack(alignment: .leading, spacing: 24) {
                        // Phone Number Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Phone Number")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                HStack(spacing: 12) {
                                    Text("+\(settingsViewModel.countryCode)")
                                        .font(.body)
                                        .foregroundColor(.black)
                                    
                                    TextField("Enter your phone number", text: $settingsViewModel.phoneNumber)
                                        .font(.body)
                                        .foregroundColor(.black)
                                        .keyboardType(.numberPad)
                                        .onChange(of: settingsViewModel.phoneNumber) { oldValue, newValue in
                                            let filtered = newValue.filter { $0.isNumber }
                                            if filtered != newValue {
                                                settingsViewModel.phoneNumber = filtered
                                            }
                                            if filtered.count > 10 {
                                                settingsViewModel.phoneNumber = String(filtered.prefix(10))
                                            }
                                            if phoneNumberError != nil {
                                                phoneNumberError = nil
                                            }
                                        }
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        // Phone verification logic here if needed
                                    }) {
                                        Text(hasClickedChangePhoneNumber ? "Verify" : "Change")
                                            .font(.subheadline)
                                            .foregroundColor(.black)
                                    }
                                    .disabled(settingsViewModel.isUpdating || settingsViewModel.isLoading)
                                }
                                .padding()
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(phoneNumberError != nil ? Color.red : Color.black.opacity(0.2), lineWidth: phoneNumberError != nil ? 1.5 : 1)
                                )
                                .padding(.horizontal)
                                
                                if let error = phoneNumberError {
                                    HStack(spacing: 4) {
                                        Image(systemName: "exclamationmark.circle.fill")
                                            .font(.caption)
                                        Text(error)
                                            .font(.caption)
                                    }
                                    .foregroundColor(.red)
                                    .padding(.horizontal, 20)
                                    .transition(.opacity)
                                }
                            }
                        }
                        
                        // Email Address Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email address")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                            
                            HStack {
                                TextField("Enter your email", text: $settingsViewModel.email)
                                    .font(.body)
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
                                Button(action: {
                                    Task {
                                        await settingsViewModel.updateEmail(newEmail: settingsViewModel.email)
                                    }
                                }) {
                                    Text("Change")
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                }
                                .disabled(settingsViewModel.isUpdating || settingsViewModel.isLoading)
                            }
                            .padding()
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.black.opacity(0.2), lineWidth: 1)
                            )
                            .padding(.horizontal)
                        }
                        
                        // OTP Verification View placeholder
                        if hasClickedChangePhoneNumber {
                            VStack {
                                Text("Please enter the OTP sent to your phone number")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal)
                            }
                        }
                        Spacer()
                    }
                    
                    // Loading Overlay Restricted to Content Area
                    if settingsViewModel.isUpdating || settingsViewModel.isLoading {
                        ZStack {
                            ProgressView(settingsViewModel.isLoading ? "Loading contact details..." : "Updating email...")
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 5)
                        }
                        .transition(.opacity)
                    }
                }
            }
            
            // Toast Notification (Floating on top of everything)
            if settingsViewModel.showToast {
                VStack {
                    Spacer()
                    HStack {
                        Image(systemName: settingsViewModel.isErrorToast ? "exclamationmark.triangle.fill" : "checkmark.circle.fill")
                            .foregroundColor(.white)
                        Text(settingsViewModel.toastMessage)
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .medium))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(settingsViewModel.isErrorToast ? Color.red : AppTheme.foregroundPink)
                    .cornerRadius(25)
                    .shadow(radius: 4)
                    .padding(.bottom, 50)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                .zIndex(10)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            Task {
                await settingsViewModel.fetchContactDetails()
            }
        }
        .alert("Error", isPresented: $settingsViewModel.showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(settingsViewModel.errorMessage ?? "An unknown error occurred.")
        }
    }
}

#Preview {
    ContactDetailsView()
}
