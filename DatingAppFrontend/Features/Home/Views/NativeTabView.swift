//
//  NativeTabView.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 25/01/26.
//

import SwiftUI

struct NativeTabView: View {
    var body: some View {
        TabView {
            DiscoverView()
                .tabItem {
                    Image("HeartIcon_tabBar")
                }
            DiscoverView()
                .tabItem {
                    Image("ChatIcon")
                }

            LandingScreenView()
                .tabItem {
                    Image("NotificationIcon")
                }

            LandingScreenView()
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
