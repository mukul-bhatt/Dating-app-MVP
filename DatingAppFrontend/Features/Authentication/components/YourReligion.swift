//
//  YourReligion.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 11/01/26.


import SwiftUI

 // Your Religion
    
    struct YourReligion: View {
        
        
        @ObservedObject var viewModel: ProfileViewModel
        
        var title: String
        
        var isMultiSelect: Bool = false // Flag to switch modes
        
//        @Binding var selectedReligion: String?
        
        private func handleSelection(for name: String) {
                if isMultiSelect {
                    if viewModel.selectedPartnerReligions.contains(name) {
                        viewModel.selectedPartnerReligions.remove(name)
                    } else {
                        viewModel.selectedPartnerReligions.insert(name)
                    }
                } else {
                    // Single select: clear everything else and just keep this one
                    viewModel.selectedReligion = name
                }
            }
        
        // 2. Helper function to check selection state
            func checkSelection(_ name: String) -> Bool {
                if isMultiSelect {
                    return viewModel.selectedPartnerReligions.contains(name)
                } else {
                    return viewModel.selectedReligion == name
                }
            }
        
        
        let religionOptions: [(String, String, Bool)] = [
            ("Hinduism", "🕉️", false),   // text emoji
            ("Buddhist", "☸️", false),   // text emoji
            ("Islam", "☪️", false),       // text emoji
            ("Jainism", "hand.raised.fill", true), // SF Symbol
            ("Christianity", "✝️", false), // text emoji
            ("Sikhism", "☬", false),     // text emoji
            ("Atheist", "atom", true),    // SF Symbol
            ("Judaism", "starofdavid", true), // SF Symbol (might
//            2need fallback if iOS <17, used generic)
            ("Open to all", "checkmark", true) // SF Symbol
        ]
        
        var body: some View {
            // 4. Religion Section (Grid Layout)
            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 10) {
                    ForEach(religionOptions, id: \.0) { option in
                        let name = option.0
                        let isSelected = checkSelection(name)
                        
                        
                        Button(action: {
//                            viewModel.selectedReligion = name
                            handleSelection(for: name)
                        }) {
                            HStack {
        
                                Image(name)
                                    .renderingMode(.template)
                                    .foregroundColor(isSelected ? .white : .primary)
                            
                                
                                Text(name)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(isSelected ? .white : .primary)
                                    .fixedSize(horizontal: true, vertical: false) // Prevents truncation
                            }
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(isSelected ? Color("ButtonColor") : Color.clear)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(isSelected ? Color("ButtonColor") : .secondary, lineWidth: isSelected ? 2 : 1)
                            )
                        }
                    }
                }
            }
        }
    }
    
    
