//
//  LoginOtpVerificationView.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 07/01/26.
//

import SwiftUI

struct LoginOtpVerificationView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @State private var enteredOtp: [String] = Array(repeating: "", count: 4)
    @State private var navigateToImageScreen : Bool = false
    
    var combinedOtp: String {
        enteredOtp.joined()
    }
    
    
    func verifyLoginOtpAndNavigate() {
            Task {
                do {
                    // 1. Wait for the server response
                    try await viewModel.callBackendWithVerifyEndpoint(otp: combinedOtp)
                    
                    // 2. SUCCESS: Update UI on the main thread
                    await MainActor.run {
                        navigateToImageScreen = true
                    }
                    
                } catch {
                    // 3. FAILURE: Navigation won't happen, handle the error here
                    print("❌ Verification failed: \(error)")
                }
            }
        
    }
    
    
    
    var body: some View {
        OTPVerificationView(viewModel: viewModel, otpText: $enteredOtp, screenType: "Welcome Back!", actionForPrimaryButton: verifyLoginOtpAndNavigate )
            .navigationDestination(isPresented: $navigateToImageScreen) {
                ImageSelectionView(viewModel: viewModel) // The screen you want to go to next
            }
    }
}

//#Preview {
//    LoginOtpVerificationView()
//}
