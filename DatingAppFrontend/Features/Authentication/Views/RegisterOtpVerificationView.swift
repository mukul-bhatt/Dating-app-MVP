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
    @Binding var path: NavigationPath
    @State private var enteredOtp: [String] = Array(repeating: "", count: 4)
    @State var navigateToImageScreen : Bool = false
    @State private var showInvalidOtpError = false
    
    var combinedOtp: String {
        enteredOtp.joined()
    }
    
    func verifyOtpAndNavigate() {
        Task {
            do {
                // The NetworkManager will try the call, and if it hits a 401,
                // it will refresh the token and retry BEFORE returning the response here.
                let response = try await viewModel.callBackendWithVerifyEndpoint(otp: combinedOtp)
                
                if response.success {
                    await MainActor.run {
                        authViewModel.saveTokenFromResponse(response)
                        viewModel.updateAuthToken(authViewModel.authToken ?? "")
//                        path = NavigationPath()
                        path.append(Route.imageSelectionView)
                    }
                }
            } catch {
                // If it lands here, it means either the internet is out
                // or even the Refresh Token was expired.
                await MainActor.run {
                    showInvalidOtpError = true
                }
                print("❌ Final failure after retries: \(error)")
            }
        }
    }
    
    var body: some View {
        
        OTPVerificationView(viewModel:viewModel, otpText: $enteredOtp, screenType: "Register with Us!", actionForPrimaryButton: verifyOtpAndNavigate, showInvalidOtpError: showInvalidOtpError)
//            .navigationDestination(isPresented: $navigateToImageScreen) {
//                ImageSelectionView(viewModel: viewModel) // The screen you want to go to next
//            }
        
        
    }
    
}
