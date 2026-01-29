//
//  NativeTabView.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 25/01/26.
//

import SwiftUI

struct NativeTabView: View {
    @State private var path = NavigationPath()
    
    var body: some View {
        
        TabView {
            DiscoverView()
                .tabItem {
                    Image("HeartIcon_tabBar")
                }
            ProfileScreenView()
                .tabItem {
                    Image("ChatIcon")
                }
            
            FeedView()
                .tabItem {
                    Image("NotificationIcon")
                }

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
