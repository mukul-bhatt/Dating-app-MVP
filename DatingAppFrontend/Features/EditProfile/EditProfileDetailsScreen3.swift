//
//  EditProfileDetailsScreen3.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 11/02/26.
//

import SwiftUI

struct EditProfileDetailsScreen3: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Binding var path: NavigationPath
    @State private var showSuccessAlert = false
    @State private var isSaving = false
    @State private var showInterestsSheet = false

    var body: some View {
        ZStack {
            AppTheme.backgroundPink.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 20) {
                ProgressIndicator(currentStep: 2)
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        EditProfileTextField(label: "Job", text: $viewModel.jobTitle, placeholder: "Enter your job title")
                        EditProfileTextField(label: "Education", text: $viewModel.education, placeholder: "Enter your education")
                        
                        EditProfileLookupDropdown(label: "Your Current Relationship Status", selectionId: $viewModel.relationshipStatusId, options: viewModel.relationshipStatusOptions)
                        
                        EditProfileLookupDropdown(label: "What are you hoping to find here", selectionId: $viewModel.lookingForId, options: viewModel.lookingForOptions)
                        
                        // Interests Section
                        SelectedInterestsView(viewModel: viewModel, showInterestsSheet: $showInterestsSheet)
                    }
                }
                
                PrimaryButton(buttonText: isSaving ? "" : "Save") {
                    Task {
                        await MainActor.run { isSaving = true }
                        do {
                            // 1. Update Profile Data
                            try await viewModel.postFormDataToBackend()
                            
                            // 2. If pictures selected, upload them
                            if !viewModel.selectedImages.isEmpty {
                                try await viewModel.uploadImages()
                            }
                            
                            print("✅ All Profile Data and Images Saved")
                            await MainActor.run {
                                isSaving = false
                                showSuccessAlert = true

                            }
                        } catch {
                            print("❌ Error saving profile: \(error)")
                            await MainActor.run { isSaving = false }
                        }
                    }
                }
                .disabled(isSaving)
            }
            .onAppear {
                Task {
                    if viewModel.relationshipStatusOptions.isEmpty {
                        await viewModel.loadRelationshipOptions()
                    }
                    
                    if viewModel.lookingForOptions.isEmpty {
                        await viewModel.loadLookingForOptions()
                    }
                    
                    if viewModel.OptionsForInterests.isEmpty {
                        await viewModel.loadOptionsForInterests()
                    }
                }
            }
            .sheet(isPresented: $showInterestsSheet) {
                InterestsSelectorSheet(viewModel: viewModel)
            }
            .overlay {
                if isSaving {
                    ZStack {
                        Color.black.opacity(0.15).ignoresSafeArea()
                        ProgressView()
                            .padding(20)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                    }
                }
            }
            .alert("Success", isPresented: $showSuccessAlert) {
                Button("OK", role: .cancel) {
                    path.removeLast(path.count)
                 }
            } message: {
                Text("Your profile has been updated successfully.")
            }
            .navigationTitle("Edit Profile")
            .padding(.horizontal)
        }
    }
}

//#Preview {
//    EditProfileDetailsScreen3(viewModel: ProfileViewModel())
//}
