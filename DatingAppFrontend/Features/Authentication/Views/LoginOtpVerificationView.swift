//
//  LoginOtpVerificationView.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 07/01/26.
//

import SwiftUI

struct LoginOtpVerificationView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var viewModel: ProfileViewModel
    @State private var enteredOtp: [String] = Array(repeating: "", count: 4)
    @State private var navigateToDiscoverScreen : Bool = false
    
    var combinedOtp: String {
        enteredOtp.joined()
    }
    
    @State private var showInvalidOtpError = false
    
    func verifyLoginOtpAndNavigate() {
            Task {
                do {
                    // 1. Wait for the server response
                    
                    let response = try await viewModel.callBackendWithVerifyEndpoint(otp: combinedOtp)
                    // 2. SUCCESS: Update UI on the main thread
                    showInvalidOtpError = false
                    await MainActor.run {
                        navigateToDiscoverScreen = true
                    }
                    
                    // Save the response into the USER DEFAULTS
                    
                    if response.success{
                        authViewModel.saveTokenFromResponse(response, expiresInHours: 12)
                        viewModel.updateAuthToken(authViewModel.authToken ?? "" )
                        
                        // Only if otp is correct, navigate to next screen
                        await MainActor.run {
                            navigateToDiscoverScreen = true
                        }
                       
                    }else{
                        print("❌ Verification failed: \(response.message)")
                    }
                    
                    
                } catch {
                    // 3. FAILURE: Navigation won't happen, handle the error here
                    showInvalidOtpError = true
                    
                    print("❌ Verification failed: \(error)")
                }
            }
        
    }
    
    
    
    var body: some View {
        OTPVerificationView(viewModel: viewModel, otpText: $enteredOtp, screenType: "Welcome Back!", actionForPrimaryButton: verifyLoginOtpAndNavigate, showInvalidOtpError: showInvalidOtpError )
            .navigationDestination(isPresented: $navigateToDiscoverScreen) {
               DiscoverView() // The screen you want to go to next
            }
    }
}

//#Preview {
//    LoginOtpVerificationView()
//}
