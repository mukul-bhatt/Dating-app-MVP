//
//  InterestsSelectorSheet.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 12/02/26.
//

import SwiftUI

struct InterestsSelectorSheet: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Environment(\.dismiss) var dismiss
    @State private var hasError = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.backgroundPink.ignoresSafeArea()
                
                VStack(spacing: 16) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Select Your Interests")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Choose up to 5 interests")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)
                    
                    // Interests Grid
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
                        .padding(.top, 10)
                    }
                    
                    // Error message
                    if hasError {
                        Text("You can select up to 5 interests")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    
                    // Done Button
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Done")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(AppTheme.foregroundPink)
                            .cornerRadius(30)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            Task {
                if viewModel.OptionsForInterests.isEmpty {
                    await viewModel.loadOptionsForInterests()
                }
            }
        }
    }
    
    func toggleSelection(for interest: InterestOption) {
        if viewModel.selectedInterestIds.contains(interest.id) {
            viewModel.selectedInterestIds.remove(interest.id)
            hasError = false
        } else {
            if viewModel.selectedInterestIds.count < 5 {
                viewModel.selectedInterestIds.insert(interest.id)
                hasError = false
            } else {
                hasError = true
            }
        }
    }
}
