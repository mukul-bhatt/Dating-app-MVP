//
//  MainTabView.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 22/01/26.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Content based on selected tab
            Group {
                switch selectedTab {
                case 0:
                    DiscoverView()
                case 1:
                    LandingScreenView()
                case 2:
                    DiscoverView()
                case 3:
                    LandingScreenView()
                default:
                    DiscoverView()
                }
            }
            
            // Custom Tab Bar
            CustomTabBar(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(.keyboard)
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack(spacing: 0) {
            // Tab Items
            TabBarItem(icon: "house.fill", isSelected: selectedTab == 0)
                .onTapGesture { selectedTab = 0 }
            
            TabBarItem(icon: "magnifyingglass", isSelected: selectedTab == 1)
                .onTapGesture { selectedTab = 1 }
            
            TabBarItem(icon: "message.fill", isSelected: selectedTab == 2)
                .onTapGesture { selectedTab = 2 }
            
            TabBarItem(icon: "person.fill", isSelected: selectedTab == 3)
                .onTapGesture { selectedTab = 3 }
        }
        .frame(height: 70)
        .background(
            RoundedRectangle(cornerRadius: 35)
                .fill(Color(red: 0.91, green: 0.33, blue: 0.55))
                .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: -5)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
}

struct TabBarItem: View {
    let icon: String
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(isSelected ? .white : .white.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
    }
}
