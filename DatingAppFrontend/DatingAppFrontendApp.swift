//
//  DatingAppFrontendApp.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 26/12/25.
//

import SwiftUI

@main
struct DatingAppFrontendApp: App {
    
    @StateObject var authViewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            if authViewModel.isAuthenticated {
                
//                MainTabView()
                NativeTabView()
//                    .environmentObject(authViewModel)??????????????
                
            }else{
                LandingScreenView()
                    .environmentObject(authViewModel)
                
                
            }
        }
    }
    
}
