//
//  InterestsView.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 11/01/26.
//


import SwiftUI

struct InterestsView: View {
    
    // MARK: - State & Data
//    @State private var selectedInterests: Set<String> = []
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var viewModel: ProfileViewModel
    @Binding var path: NavigationPath
//    @State var navigateToSettingUpScreen = false
    @State private var hasClickedDoneButton = false
    @State private var isLoading = false
    
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
    
    // Custom Colors (Matching your theme)
    let backgroundColor = Color("BrandColor") // Brand Background
    let brandPink = Color("ButtonColor")// The dark pink/magenta
    
    var body: some View {
//        NavigationStack{
        ZStack {
            // 1. Background
            backgroundColor.ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                // 2. Header
                VStack(spacing: 12) {
                    Text("Choose your Interests")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text("Choose any 5 interests to get started")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 20)
                .padding(.bottom, 30)
                
                // 3. Grid of Interests
                ScrollView(showsIndicators: false) {
                    FlowLayout(items: viewModel.OptionsForInterests) { interest in

                            InterestTag(
                                text: interest.interestsName,
                                isSelected: viewModel.selectedInterestIds.contains(interest.id)
                            ) {
                                toggleSelection(for: interest)
                            }

                    }
                    .padding(.horizontal, 20)
//                    .padding(.bottom, 100) // Space for the Done button
                    .padding(.top, 10)
                }
                
                Spacer()
                
               
            }
            
            // 4. "Done" Button (Floating at bottom)
            VStack {
                Spacer()
                if hasClickedDoneButton, let errorMessage = viewModel.errorMessageForInterestSelectionScreen {
                    HStack(spacing: 4) {
                        Image(systemName: "exclamationmark.circle.fill")
                        Text(errorMessage)
                    }
                    .font(.caption)
                    .foregroundColor(.red)
                }
                
                Button(action: {
                    print("Selected: \(viewModel.selectedInterestIds)")
                    hasClickedDoneButton = true
                    viewModel.printDataSnapshot()
                    if viewModel.isFormValid && viewModel.isInterestSelectionValid{
                        // Call function to post all profile data to backend
                        isLoading = true
                        Task{
                            do{
                                try await viewModel.postFormDataToBackend()
                                print("✅ Profile data uploded successfully")
                                
                                // 2. ONLY navigate if the line above succeeded
                                            await MainActor.run {
                                                print("✅ Profile data uploaded successfully")
//                                                navigateToSettingUpScreen = true
                                                isLoading = false
                                                authViewModel.finalizeLogin()
                                            }
                            }catch{
                                print("❌ Upload failed: \(error)")
                            }
                            
                        }
                    }else{
                        print("Else block excecuted, form is not valid")
                    }
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
            
            if isLoading{
                SettingUpScreen()
            }
        }.onAppear{
            Task{
                await viewModel.loadOptionsForInterests()
            }
        }
//        }
//        .navigationDestination(isPresented: $navigateToSettingUpScreen){
//            SettingUpScreen()
//        }
    }
    
    // MARK: - Logic
    
    func toggleSelection(for interest: InterestOption) {
        if viewModel.selectedInterestIds.contains(interest.id) {
            viewModel.selectedInterestIds.remove(interest.id)
        } else {
            // Optional: Enforce limit of 5
            if viewModel.selectedInterestIds.count < 5 {
                viewModel.selectedInterestIds.insert(interest.id)
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
    let brandPink = Color("BrandColor")
    let unselectedBg = Color.clear // Very light pink
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
//                .frame(maxWidth: .infinity)
                .frame(height: 45) // Fixed height to match uniform grid
                .background(isSelected ? Color("ButtonColor") : unselectedBg)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isSelected ? brandPink : Color.primary, lineWidth: isSelected ? 0 : 1)
                )
        }
    }
}

//#Preview {
//    InterestsView(viewModel: <#ProfileViewModel#>)
//}
