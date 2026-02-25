//
//  BlockListView.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 19/02/26.
//

import SwiftUI

struct BlockListView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = BlockListViewModel()
    
    // Grid layout
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ZStack {
            AppTheme.backgroundPink.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.black)
                            .padding(12)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                    }
                    
                    Spacer()
                    
                    Text("Block list")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    // Invisible spacer to center the title
                    Color.clear
                        .frame(width: 42, height: 42)
                }
                .padding(.horizontal)
                .padding(.top, 8)
                .padding(.bottom, 24)
                
                ScrollView {
                    if viewModel.isLoading {
                        VStack {
                            Spacer()
                            ProgressView()
                                .padding()
                            Text("Loading block list...")
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, minHeight: 300)
                    } else if let error = viewModel.errorMessage {
                        VStack(spacing: 16) {
                            Spacer()
                            Image(systemName: "exclamationmark.triangle")
                                .font(.largeTitle)
                                .foregroundColor(.orange)
                            Text(error)
                                .foregroundColor(.gray)
                            Button("Retry") {
                                Task {
                                    await viewModel.fetchBlacklistedUsers()
                                }
                            }
                            .padding(.horizontal, 24)
                            .padding(.vertical, 10)
                            .background(AppTheme.foregroundPink)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, minHeight: 300)
                    } else if viewModel.blacklistedUsers.isEmpty {
                        VStack(spacing: 16) {
                            Spacer()
                            Image(systemName: "person.slash.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.gray.opacity(0.3))
                            
                            Text("No block listed users")
                                .font(.headline)
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, minHeight: 400)
                    } else {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(viewModel.blacklistedUsers) { user in
                                BlacklistedUserCard(user: user, viewModel: viewModel)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                    }
                }
            }
            
            // Overlay for unblocking spinner
            if viewModel.isUnblocking {
                ZStack {
                    Color.black.opacity(0.2).ignoresSafeArea()
                    ProgressView()
                        .padding(20)
                        .background(Color.white)
                        .cornerRadius(12)
                }
            }
        }
        .navigationBarHidden(true)
        .task {
            await viewModel.fetchBlacklistedUsers()
        }
        .overlay(
            Group {
                if viewModel.showUnblockAlert, let user = viewModel.userToUnblock {
                    ZStack {
                        Color.black.opacity(0.8).ignoresSafeArea()
                        
                        VStack {
                            Spacer()
                            
                            VStack(spacing: 20) {
                                Text("Unblock")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                
                                Text("Are you sure you want to unblock\n**\(user.fullName ?? "this user")?**")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                                
                                HStack(spacing: 20) {
                                    Button(action: {
                                        withAnimation {
                                            viewModel.showUnblockAlert = false
                                        }
                                    }) {
                                        Text("Cancel")
                                            .font(.subheadline)
                                            .foregroundColor(.primary)
                                            .frame(width: 120, height: 50)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1.5)
                                            )
                                    }
                                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                                    
                                    Button(action: {
                                        Task {
                                            let _ = await viewModel.unblockUser(userId: user.blacklistedUserId)
                                            withAnimation {
                                                viewModel.showUnblockAlert = false
                                            }
                                        }
                                    }) {
                                        Text("Unblock")
                                            .font(.subheadline)
                                            .foregroundColor(AppTheme.foregroundPink)
                                            .frame(width: 120, height: 50)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(AppTheme.foregroundPink.opacity(0.7), lineWidth: 1.5)
                                            )
                                    }
                                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                                }
                            }
                            .padding(.vertical, 30)
                            .padding(.horizontal, 20)
                            .background(Color.white)
                            .cornerRadius(24)
                            .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
                            .padding(.horizontal, 30)
                            
                            Spacer()
                        }
                    }
                }
            }
        )
    }
}

// Card Component for Blacklisted User
struct BlacklistedUserCard: View {
    let user: BlacklistedUser
    @ObservedObject var viewModel: BlockListViewModel
    
    var body: some View {
        VStack(spacing: 6) {
            // Profile Image
            AsyncImage(url: URL(string: user.profilePicture ?? user.latestProfileImage ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                ZStack {
                    Color.gray.opacity(0.3)
                    Image(systemName: "person.fill")
                        .foregroundColor(.gray)
                }
            }
            .frame(width: 100, height: 100)
            .clipShape(Circle())
            .padding(.top, 16)
            
            // Name & Age
            Text("\(user.fullName ?? "User"), \(user.age ?? 0)")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.black)
                .lineLimit(1)
            
            // Tags
            let tags = [user.religion, user.sexuality, user.gender].compactMap { $0 }.filter { !$0.isEmpty }
            
            if !tags.isEmpty {
                Text(tags.joined(separator: " • "))
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .padding(.horizontal, 8)
                    .frame(height: 30)
            } else {
                Spacer().frame(height: 30)
            }
            
            // Unblock Button
            Button(action: {
                withAnimation {
                    viewModel.userToUnblock = user
                    viewModel.showUnblockAlert = true
                }
            }) {
                Text("Unblock")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(AppTheme.foregroundPink)
                    .cornerRadius(8)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    BlockListView()
}
