//
//  YourPronouns.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 11/01/26.
//

import SwiftUI

// Your pronouns Section
    struct YourPronouns: View {
        
        @ObservedObject var viewModel: ProfileViewModel
        
//        var isNotValid: Bool{
//            viewModel.hasStartedTypingInLocationField && !viewModel.isValidPronouns
//        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 10) {
                
                // 4. Your Pronouns Dropdown
                CustomDropdown(
                    label: "Your Pronouns",
                    selection: $viewModel.pronounId,
                    options: viewModel.pronounOptions
                )
                
                

            }
            .onAppear{
                Task{
                    await viewModel.loadOptionsForPronouns()
                }
                        }
        }
    }

    
   

//                if isNotValid{
//                    HStack(spacing: 4) {
//                        Image(systemName: "exclamationmark.circle.fill")
//                        Text("Pronouns cannot contain numbers")
//                    }
//                    .font(.caption)
//                    .foregroundColor(.red)
//                    .transition(.opacity)
//                }



//
//                Text("Your Pronouns")
//                    .font(.headline)
//                    .foregroundColor(.black)
                
//                TextField("Add your pronouns", text: $viewModel.pronouns)
//                    .padding()
//                    .cornerRadius(10)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 10)
//                            .stroke(
//                                isNotValid
//                                ? Color.red.opacity(0.5)
//                                : Color.primary.opacity(0.5)
//                            )
//                    )
//                    .onChange(of: viewModel.pronouns) { oldValue, newValue in
//                        if !newValue.isEmpty {
//                            viewModel.hasStartedTypingInLocationField = true
//                        }
//                    }
