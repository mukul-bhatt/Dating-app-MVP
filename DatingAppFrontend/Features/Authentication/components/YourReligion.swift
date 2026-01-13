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
        
        // 1. Update to accept ID (Int) instead of Name (String)
            private func handleSelection(for id: Int) {
                if isMultiSelect {
                    // Modify the Set of IDs
                    if viewModel.selectedPartnerReligionsIds.contains(id) {
                        viewModel.selectedPartnerReligionsIds.remove(id)
                    } else {
                        viewModel.selectedPartnerReligionsIds.insert(id)
                    }
                } else {
                    // Set the single ID
                    viewModel.selectedReligionId = id
                }
            }

            // 2. This function is now consistent with handleSelection
            func checkSelection(_ id: Int) -> Bool {
                if isMultiSelect {
                    return viewModel.selectedPartnerReligionsIds.contains(id)
                } else {
                    return viewModel.selectedReligionId == id
                }
            }
        
//        let religionOptions: [(String, String, Bool)] = [
//            ("Hinduism", "🕉️", false),   // text emoji
//            ("Buddhist", "☸️", false),   // text emoji
//            ("Islam", "☪️", false),       // text emoji
//            ("Jainism", "hand.raised.fill", true), // SF Symbol
//            ("Christianity", "✝️", false), // text emoji
//            ("Sikhism", "☬", false),     // text emoji
//            ("Atheist", "atom", true),    // SF Symbol
//            ("Judaism", "starofdavid", true), // SF Symbol (might
////            2need fallback if iOS <17, used generic)
//            ("Open to all", "checkmark", true) // SF Symbol
//        ]
        
        var body: some View {
            // 4. Religion Section (Grid Layout)
            VStack(alignment: .leading, spacing: 10) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 10) {
                    ForEach(viewModel.religionOptions) { option in
                        let name = option.name
                        let isSelected = checkSelection(option.id)
                        
                        
                        Button(action: {
//                            viewModel.selectedReligion = name
//                            handleSelection(for: name)
                            handleSelection(for: option.id)
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
            .onAppear {
                // Trigger the fetch if the list is empty
                if viewModel.religionOptions.isEmpty {
                    Task { await viewModel.fetchMasterOptionsForReligion() }
                }
            }
        }
    }
    
    
