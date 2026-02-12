//
//  SelectedInterestsView.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 12/02/26.
//

import SwiftUI

struct SelectedInterestsView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Binding var showInterestsSheet: Bool
    
    var selectedInterests: [InterestOption] {
        viewModel.OptionsForInterests.filter { viewModel.selectedInterestIds.contains($0.id) }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Interests")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            FlowLayout(items: selectedInterests) { interest in
                HStack(spacing: 6) {
                    Text(interest.interestsName)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                    
                    Button(action: {
                        viewModel.selectedInterestIds.remove(interest.id)
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 14)
                .background(AppTheme.foregroundPink)
                .cornerRadius(20)
            }
            
            // Add More Button
            Button(action: {
                showInterestsSheet = true
            }) {
                HStack(spacing: 6) {
                    Text("Add More")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.primary)
                    
                    Image(systemName: "plus")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.primary)
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 14)
                .background(Color.clear)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.primary.opacity(0.5), lineWidth: 1.5)
                )
            }
        }
    }
}
