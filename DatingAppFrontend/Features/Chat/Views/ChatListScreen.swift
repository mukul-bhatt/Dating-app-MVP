//
//  ChatListScreen.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 04/02/26.
//


import SwiftUI

struct ChatListScreen: View {
    var body: some View {
        ZStack{
            
            AppTheme.backgroundPink.ignoresSafeArea()
            
            VStack{
                // MARK: - Header
                headerView
                // Spacer()
                VStack(alignment: .leading, spacing: 20) {
                    Text("Online")
                        .font(.headline)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    // MARK: - Online Stories Row
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(0..<7) { _ in
                                OnlineCircleView()
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    ScrollView {
                        // MARK: - Chat List
                        VStack(spacing: 0) {
                            ForEach(0..<9) { _ in
                                ChatRowView()
                                Divider()
                                    .padding(.leading, 80)
                                    .padding(.trailing)
                            }
                        }
                    }
                    
                }
            }
        }
    }
    
    var headerView: some View {
        HStack {
            Image(systemName: "arrow.left")
            Text("Chats")
                .font(.title3)
                .fontWeight(.medium)
            Spacer()
        }
        .padding()
        .foregroundColor(.white)
        .background(AppTheme.foregroundPink)
    }
    
}

// MARK: - Subviews

struct OnlineCircleView: View {
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Circle()
                .frame(width: 65, height: 65)
                .foregroundColor(.gray.opacity(0.3)) // Replace with Image
            
            Circle()
                .frame(width: 14, height: 14)
                .foregroundColor(.green)
                .overlay(Circle().stroke(Color.white, lineWidth: 2))
        }
    }
}

struct ChatRowView: View {
    var body: some View {
        HStack(spacing: 15) {
            Circle()
                .frame(width: 55, height: 55)
                .foregroundColor(.gray.opacity(0.3)) // Replace with Image
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Mahika Malik")
                    .font(.system(size: 16, weight: .bold))
                Text("Good, I saw it just now")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text("9:56 AM")
                .font(.system(size: 12))
                .foregroundColor(.primary)
        }
        .padding()
    }
}


#Preview{
    ChatListScreen()
}
