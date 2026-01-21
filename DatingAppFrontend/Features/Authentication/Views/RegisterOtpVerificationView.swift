//
//  RegisterOtpVerificationView.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 07/01/26.
//

import SwiftUI

struct RegisterOtpVerificationView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var viewModel: ProfileViewModel
    @State private var enteredOtp: [String] = Array(repeating: "", count: 4)
    @State var navigateToImageScreen : Bool = false
    @State private var showInvalidOtpError = false
    
    var combinedOtp: String {
        enteredOtp.joined()
    }
    
    func verifyOTPandNavigate() {
        Task {
            do {
                
                // 1. Wait for the server response
                let response = try await viewModel.callBackendWithVerifyEndpoint(otp: combinedOtp)
                
                showInvalidOtpError = false
                // Save the response into the USER DEFAULTS
                
                if response.success{
                    authViewModel.saveTokenFromResponse(response, expiresInHours: 12)
                    viewModel.updateAuthToken(authViewModel.authToken ?? "" )
                    
                    // Only if otp is correct, navigate to next screen
                    await MainActor.run {
                        navigateToImageScreen = true
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
        
        OTPVerificationView(viewModel:viewModel, otpText: $enteredOtp, screenType: "Register with Us!", actionForPrimaryButton: verifyOTPandNavigate, showInvalidOtpError: showInvalidOtpError)
            .navigationDestination(isPresented: $navigateToImageScreen) {
                ImageSelectionView(viewModel: viewModel) // The screen you want to go to next
            }
        
        
    }
    
}
