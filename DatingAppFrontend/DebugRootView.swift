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
                    ImageSelectionView(viewModel: viewModel)
                }
                NavigationLink("Interest") {
                    InterestsView(viewModel: viewModel)
                }
                NavigationLink("Range Slider") {
//                    RangeSlider(minValue: 18, maxValue: 65, range: 18...65)
                    RangeSlider(minValue: $viewModel.minValue, maxValue: $viewModel.maxValue, range: 18...65)
                    
                }
                NavigationLink("Discover View") {
                    DiscoverView()
                    
                    
                }
        
            }
            .navigationTitle("Screens")
        }
    }
}
