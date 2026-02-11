//
//  NativeTabView.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 25/01/26.
//

import SwiftUI

struct NativeTabView: View {
    @State private var path = NavigationPath()
    @StateObject var viewModel = DiscoverViewModel()
    @EnvironmentObject var notificationsManager: NotificationsManager
    
    var body: some View {
        
        TabView {
//            DiscoverView(path: $path)
            DiscoverFlowView(viewModel: viewModel)
                .tabItem {
                    Image("HeartIcon_tabBar")
                }
//            ProfileScreenView(profile: viewModel.users[0])
            ChatListScreen()
                .tabItem {
                    Image("ChatIcon")
                }
            
//            FeedView()
            NotificationsScreen()
                .tabItem {
                    Image("NotificationIcon")
                }
                .badge(notificationsManager.unreadCount)

            LandingScreenView(path: $path)
                .tabItem {
                    Image("ProfileIcon")

                }
        }
        .tint(.pink)
    }
}

#Preview {
    NativeTabView()
}
