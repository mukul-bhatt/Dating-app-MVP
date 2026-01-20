//
//  RegisterOtpVerificationView.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 07/01/26.
//

import SwiftUI

struct RegisterOtpVerificationView: View {
    
    @ObservedObject var viewModel: ProfileViewModel
    @State private var enteredOtp: [String] = Array(repeating: "", count: 4)
    @State var navigateToImageScreen : Bool = false
    
    var combinedOtp: String {
        enteredOtp.joined()
    }
    
    func verifyOTPandNavigate() {
        Task {
            do {
                // 1. Wait for the server response
                try await viewModel.callBackendWithVerifyEndpoint(otp: combinedOtp)
                
                // Only if otp is correct, navigate to next screen
                
                
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
        
        OTPVerificationView(viewModel:viewModel, otpText: $enteredOtp, screenType: "Register with Us!", actionForPrimaryButton: verifyOTPandNavigate)
            .navigationDestination(isPresented: $navigateToImageScreen) {
                ImageSelectionView(viewModel: viewModel) // The screen you want to go to next
            }
        
        
    }
    
    
    
    
    //{
    //    "Mobile":"4569871526",
    //    "countryCode":"91",
    //"ProfileId":"8019",
    //"Otp":"1234"
    //}
    
    
    
}

//#Preview {
//    RegisterOtpVerificationView()
//}
