//
//  DebugRootView.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 07/01/26.
//

import SwiftUI

struct DebugRootView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Login") {
                    LoginView()
                }

                NavigationLink("LoginOTP") {
                    LoginOtpVerificationView()
                }

                NavigationLink("RegisterOTP") {
                    RegisterOtpView()
                }

                NavigationLink("Register") {
                    RegisterWithUsView()
                }

                NavigationLink("WelcomeBack") {
                    WelcomeBackView()
                }
            }
            .navigationTitle("Screens")
        }
    }
}
