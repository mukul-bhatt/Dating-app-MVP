//
//  MyMatchesView.swift
//  DatingAppFrontend
//
//  Created by Antigravity on 11/02/26.
//

import SwiftUI

struct MyMatchesView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var path: NavigationPath
    @StateObject var viewModel = MatchesViewModel()
    
    // Grid layout
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ZStack {
            AppTheme.backgroundPink.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 24) {
                // Header with back button
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
                    
                    Text("My Matches")
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
                
                ScrollView {
                    if viewModel.isLoadingMatches {
                        VStack {
                            Spacer()
                            ProgressView()
                                .padding()
                            Text("Loading your matches...")
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
                                    await viewModel.fetchMatches()
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
                    } else if viewModel.matches.isEmpty {
                        VStack {
                            Spacer()
                            Image(systemName: "heart.slash")
                                .font(.system(size: 60))
                                .foregroundColor(.gray.opacity(0.3))
                                .padding(.bottom, 16)
                            Text("No matches yet")
                                .font(.headline)
                                .foregroundColor(.gray)
                            Text("Keep exploring to find someone special!")
                                .font(.subheadline)
                                .foregroundColor(.gray.opacity(0.8))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, minHeight: 300)
                    } else {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(viewModel.matches) { match in
                                MatchCard(match: match, path: $path, viewModel: viewModel)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                    }
                }
            }
        }
        // Overlay for profile fetching spinner
        .overlay(
            Group {
                if viewModel.isFetchingProfile {
                    ZStack {
                        Color.white.opacity(0.4)
                            .ignoresSafeArea()
                        
                        ProgressView()
                            .padding(20)
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(0.1), radius: 10)
                    }
                }
            }
        )
        .navigationBarHidden(true)
        .task {
            await viewModel.fetchMatches()
        }
    }
}

// Data Model
struct MatchProfile: Identifiable {
    let id = UUID()
    let name: String
    let age: Int
    let imageUrl: String
    let tags: [String]
}

// Card Component
struct MatchCard: View {
    let match: UserMatch
    @Binding var path: NavigationPath
    @ObservedObject var viewModel: MatchesViewModel
    
    var body: some View {
        VStack(spacing: 6) {
            // Profile Image
            AsyncImage(url: URL(string: match.profilePicture ?? match.latestProfileImage ?? match.profileImage ?? "")) { image in
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
            Text("\(match.fullName ?? "User"), \(match.age ?? 0)")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.black)
                .lineLimit(1)
                .frame(height: 20)
            
            // Tags (Derived from religion, sexuality, etc.)
            let tags = [match.religion, match.sexuality, match.gender].compactMap { $0 }.filter { !$0.isEmpty }
            
            Group {
                if !tags.isEmpty {
                    Text(tags.joined(separator: " • "))
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .padding(.horizontal, 8)
                } else {
                    // Empty space to maintain height consistency
                    Color.clear
                }
            }
            .frame(height: 30)
            
            Spacer(minLength: 0)
            
            // Send Message Button
            Button(action: {
                path.append(EditProfileRoutes.chat(match))
            }) {
                Text("Send Message")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(AppTheme.foregroundPink)
                    .cornerRadius(8)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .frame(height: 250) // Fixed height for consistent cards
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .onTapGesture {
            Task {
                if let profile = await viewModel.fetchFullProfile(profileId: match.matchedUserId) {
                    path.append(EditProfileRoutes.matchProfile(profile))
                }
            }
        }
    }
}

#Preview {
    MyMatchesView(path: .constant(NavigationPath()))
}
