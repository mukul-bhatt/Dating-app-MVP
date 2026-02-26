//
//  NativeTabView.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 25/01/26.
//

import SwiftUI

struct NativeTabView: View {
//    @State private var path = NavigationPath()
    @StateObject var viewModel = DiscoverViewModel()
    @EnvironmentObject var notificationsManager: NotificationsManager
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        
        TabView(selection: $notificationsManager.selectedTab) {
//          DiscoverView(path: $path)
            DiscoverFlowView(viewModel: viewModel)
                .tabItem {
                    Image("HeartIcon_tabBar")
                }
                .tag(0)
//          ProfileScreenView(profile: viewModel.users[0])
            ChatFlowView(path: $notificationsManager.chatPath, discoverViewModel: viewModel)
                .tabItem {
                    Image("ChatIcon")
                }
                .badge(notificationsManager.unreadMessageCount)
                .tag(1)

            
//          FeedView()
            NotificationsScreen()
                .tabItem {
                    Image("NotificationIcon")
                }
                .badge(notificationsManager.unreadCount)
                .tag(2)

//          Edit Profile Flow
            EditProfileFlowView()
                .tabItem {
                    Image("ProfileIcon")

                }
                .tag(3)
        }
        .tint(.pink)
        .onAppear {
            if let userId = authViewModel.profileId {
                print("🔌 NativeTabView: Connecting socket for user \(userId)")
                ChatSocketManager.shared.connect(userId: userId)
                
                // Fetch current user profile to get global profile picture
                Task {
                    await authViewModel.fetchCurrentUserProfile()
                }
            }
        }
        .fullScreenCover(isPresented: $notificationsManager.showMatchScreen) {
            MatchView(matchData: notificationsManager.latestMatch)
        }
    }
}

#Preview {
    NativeTabView()
}
