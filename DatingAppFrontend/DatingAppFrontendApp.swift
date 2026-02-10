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
    @StateObject var notificationsManager = NotificationsManager()
    
    var body: some Scene {
        WindowGroup {
            if authViewModel.isAuthenticated {
                NativeTabView()
                    .environmentObject(authViewModel)
                    .environmentObject(notificationsManager)
                
            } else {
                AuthFlowView()
                    .environmentObject(authViewModel)
                    .environmentObject(notificationsManager)
            }
        }
    }
    
}
