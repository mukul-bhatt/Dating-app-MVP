//
//  BioSection.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 11/01/26.
//

import SwiftUI

  // Bio Section
    
    struct BioSection: View {
        
//        @Binding var bio: String
        @ObservedObject var viewModel: ProfileViewModel

        var isFromEditProfile: Bool = false
        
        var body: some View {
            // 3. Bio Section
            VStack(alignment: .leading, spacing: 10) {
                Text("Bio")
                    .font(isFromEditProfile ? .subheadline : .headline)
                    .foregroundColor(isFromEditProfile ? .secondary : .primary)
                
                VStack(alignment: .trailing, spacing: 5) {
                    TextEditor(text: $viewModel.bio)
                        .frame(height: 100)
                        .padding(10)
                        .scrollContentBackground(.hidden) // Required to change TextEditor bg
                        .background(Color.clear)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.secondary, lineWidth: 1)
                        )
                        .onChange(of: viewModel.bio) { oldValue, newValue in
                            if newValue.count > 100 {
                                viewModel.bio = String(newValue.prefix(100))
                            }
                        }
                    
                    Text("\(viewModel.bio.count)/100")
                        .font(.caption)
                        .foregroundColor(.primary)
                }
                
                if viewModel.hasAttemptedSubmit, let errorMessage =  viewModel.errorMessageForBioField{
                    HStack(spacing: 4) {
                        Image(systemName: "exclamationmark.circle.fill")
                        Text(errorMessage)
                    }
                    .font(.caption)
                    .foregroundColor(.red)
                    .transition(.opacity)
                }
            }
        }
    }
    
