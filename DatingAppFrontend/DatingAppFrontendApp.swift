//
//  DatingAppFrontendApp.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 26/12/25.
//

import SwiftUI

@main
struct DatingAppFrontendApp: App {
    
    @State var authViewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            if authViewModel.isAuthenticated {
                DiscoverView()
                    .environmentObject(authViewModel)
                    .onAppear{
                        checkTokenValidity()
                    }
            }else{
                LandingScreenView()
                    .environmentObject(authViewModel)

            }
        }
    }
    
    func checkTokenValidity() {
           if !authViewModel.isTokenValid() {
               print("Token expired, logging out")
               authViewModel.logout()
           }
       }
}
