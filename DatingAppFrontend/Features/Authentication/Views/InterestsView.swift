//
//  InterestsView.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 11/01/26.
//


import SwiftUI

struct InterestsView: View {
    
    // MARK: - State & Data
    // In a real app, you might move `selectedInterests` to your ProfileViewModel
    @State private var selectedInterests: Set<String> = []
    
    // Mock Data based on the image
    let interestsList = [
        "Cooking", "Baking", "Crochet", "Football",
        "Dancing", "Singing", "Hiking", "Travelling",
        "Painting", "Gaming", "Reading", "Yoga",
        "Photography", "Music", "Movies", "Fashion",
        "Karaoke", "Horse Riding", "Diving", "Pottery",
        "Foodie", "Art", "Design", "Politics",
        "Gardening", "Gym", "Running", "Writing"
    ]
    
    // Grid Layout: 4 columns as seen in the screenshot
    let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    // Custom Colors (Matching your theme)
    let backgroundColor = Color("BrandColor") // Brand Background
    let brandPink = Color("ButtonColor")// The dark pink/magenta
    
    var body: some View {
        ZStack {
            // 1. Background
            backgroundColor.ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                // 2. Header
                VStack(spacing: 12) {
                    Text("Choose your Interests")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text("Choose any 5 interests to get started")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 20)
                .padding(.bottom, 30)
                
                // 3. Grid of Interests
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(interestsList, id: \.self) { interest in
                            InterestTag(
                                text: interest,
                                isSelected: selectedInterests.contains(interest)
                            ) {
                                toggleSelection(for: interest)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100) // Space for the Done button
                    .padding(.top, 10)
                }
                
                Spacer()
            }
            
            // 4. "Done" Button (Floating at bottom)
            VStack {
                Spacer()
                Button(action: {
                    print("Selected: \(selectedInterests)")
                }) {
                    Text("Done")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(brandPink)
                        .cornerRadius(30)
                }
                .padding(.horizontal, 25)
                .padding(.bottom, 30)
            }
        }
    }
    
    // MARK: - Logic
    
    func toggleSelection(for interest: String) {
        if selectedInterests.contains(interest) {
            selectedInterests.remove(interest)
        } else {
            // Optional: Enforce limit of 5
            if selectedInterests.count < 5 {
                selectedInterests.insert(interest)
            }
        }
    }
}

// MARK: - Subcomponent: Interest Tag Button

struct InterestTag: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    // Colors
    let brandPink = Color(red: 0.9, green: 0.28, blue: 0.48)
    let unselectedBg = Color.clear // Very light pink
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(isSelected ? .white : .black)
                .padding(.horizontal, 10)
                .frame(maxWidth: .infinity)
                .frame(height: 45) // Fixed height to match uniform grid
                .background(isSelected ? brandPink : unselectedBg)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isSelected ? brandPink : Color.black, lineWidth: isSelected ? 0 : 1)
                )
        }
    }
}

#Preview {
    InterestsView()
}
