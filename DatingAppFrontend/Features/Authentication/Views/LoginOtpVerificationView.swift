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
    @Binding var path: NavigationPath
    @State private var enteredOtp: [String] = Array(repeating: "", count: 4)
//    @State private var navigateToDiscoverScreen : Bool = false
   

    
    var combinedOtp: String {
        enteredOtp.joined()
    }
    
    @State private var showInvalidOtpError = false
    
    func verifyLoginOtpAndNavigate() {
        Task {
            do {
                // The NetworkManager will try the call, and if it hits a 401,
                // it will refresh the token and retry BEFORE returning the response here.
                let response = try await viewModel.callBackendWithVerifyEndpoint(otp: combinedOtp)
                
                if response.success {
                    // If user is not a new user, only then you navigate next i.e discove screen, otherwise take them to Register screen.
                    await MainActor.run {
                        authViewModel.saveTokenFromResponse(response)
                        authViewModel.finalizeLogin()
                        path.append(Route.imageSelectionView) // Replace with discover view
                    }
                    
                    
                }else{
                    // when the User is a new User - take him/her to register screen
                    path = NavigationPath()
                    path.append(Route.register)
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
        OTPVerificationView(viewModel: viewModel, otpText: $enteredOtp, screenType: "Welcome Back!", actionForPrimaryButton: verifyLoginOtpAndNavigate, showInvalidOtpError: showInvalidOtpError )
//            .navigationDestination(isPresented: $navigateToDiscoverScreen) {
//               DiscoverView()
//            }
    }
}

//#Preview {
//    LoginOtpVerificationView()
//}
