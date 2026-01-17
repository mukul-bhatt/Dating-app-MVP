//
//  DebugRootView.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 07/01/26.
//

import SwiftUI

struct DebugRootView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Login") {
                    LoginView(viewModel: viewModel)
                }

                NavigationLink("LoginOTP") {
                    LoginOtpVerificationView(viewModel: viewModel)
                }

                NavigationLink("RegisterOTP") {
                    RegisterOtpVerificationView(viewModel: viewModel)
                }

                NavigationLink("Register") {
                    RegisterWithUsView(viewModel: viewModel)
                }

                NavigationLink("ProfileSetup") {
                    ProfileSetup(viewModel: viewModel)
                }
                NavigationLink("Splash Screen") {
                    LandingScreenView()
                }
                NavigationLink("Image Upload") {
                    ImageSelectionView()
                }
                NavigationLink("Interest") {
                    InterestsView(viewModel: viewModel)
                }
        
            }
            .navigationTitle("Screens")
        }
    }
}
