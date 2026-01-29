//
//  AuthFlowView.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 25/01/26.
//

import SwiftUI

enum Route: Hashable {
    case login
    case loginOtp
    case register
    case registerOtp
    case imageSelectionView
    case profileSetup
    case interests
}

struct AuthFlowView: View {

    @StateObject var viewModel = ProfileViewModel()
    @State var path = NavigationPath()

    var body: some View {

        NavigationStack(path: $path) {
            
            LandingScreenView(path: $path)
                .navigationDestination(for: Route.self) { route in
                    
                switch route {
                case .login:
                    LoginView(viewModel: viewModel, path: $path)

                case .loginOtp:
                    LoginOtpVerificationView(viewModel: viewModel, path: $path)

                case .register:
                    RegisterWithUsView(viewModel: viewModel, path: $path)

                case .registerOtp:
                    RegisterOtpVerificationView(viewModel: viewModel, path: $path)

                case .imageSelectionView:
                    ImageSelectionView(viewModel: viewModel, path: $path)

                case .profileSetup:
                    ProfileSetup(viewModel: viewModel, path: $path)

                case .interests:
                    InterestsView(viewModel: viewModel, path: $path)
                }
            }
        }
        
    }
}
