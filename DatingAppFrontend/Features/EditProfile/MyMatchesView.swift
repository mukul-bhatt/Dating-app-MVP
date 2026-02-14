//
//  MyMatchesView.swift
//  DatingAppFrontend
//
//  Created by Antigravity on 11/02/26.
//

import SwiftUI

struct MyMatchesView: View {
    @Environment(\.dismiss) var dismiss
    
    // Grid layout
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    // Sample Data
    let matches = [
        MatchProfile(name: "Sarah Khan", age: 26, imageUrl: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=2787&auto=format&fit=crop", tags: ["Taurus", "Muslim", "Bisexual", "Vegan"]),
        MatchProfile(name: "Ishaan Kapoor", age: 32, imageUrl: "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=2787&auto=format&fit=crop", tags: ["Leo", "Hindu", "Straight", "Dog Parent"]),
        MatchProfile(name: "Lavanya Arora", age: 21, imageUrl: "https://images.unsplash.com/photo-1517841905240-472988babdf9?q=80&w=2787&auto=format&fit=crop", tags: ["Taurus", "Hindu", "Bisexual", "Musician"])
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
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(matches) { match in
                            MatchCard(match: match)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
        }
        .navigationBarHidden(true)
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
    let match: MatchProfile
    
    var body: some View {
        VStack(spacing: 12) {
            // Profile Image
            AsyncImage(url: URL(string: match.imageUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 100, height: 100)
            .clipShape(Circle())
            .padding(.top, 16)
            
            // Name & Age
            Text("\(match.name), \(match.age)")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.black)
            
            // Tags
            if !match.tags.isEmpty {
                Text(match.tags.joined(separator: " • "))
                    .font(.system(size: 10))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .padding(.horizontal, 4)
            }
            
            // Send Message Button
            Button(action: {
                // Handle message action
            }) {
                Text("Send Message") // Typo fixed from 'Mesage' in design
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(AppTheme.foregroundPink) // Using BrandColor for pink button
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
    MyMatchesView()
}
