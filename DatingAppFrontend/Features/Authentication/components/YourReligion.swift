//
//  YourReligion.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 11/01/26.
//

import SwiftUI

 // Your Religion
    
    struct YourReligion: View {
        
        
        
        var title: String
        @Binding var selectedReligion: String?
        
        let religionOptions: [(String, String, Bool)] = [
            ("Hinduism", "🕉️", false),   // text emoji
            ("Buddhist", "☸️", false),   // text emoji
            ("Islam", "☪️", false),       // text emoji
            ("Jainism", "hand.raised.fill", true), // SF Symbol
            ("Christianity", "✝️", false), // text emoji
            ("Sikhism", "☬", false),     // text emoji
            ("Atheist", "atom", true),    // SF Symbol
            ("Judaism", "starofdavid", true), // SF Symbol (might need fallback if iOS <17, used generic)
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
                        //                            let icon = option.1
                        //                            let isSFSymbol = option.2
                        
                        Button(action: {
                            selectedReligion = name
                        }) {
                            HStack {
                                //                                    if isSFSymbol {
                                //                                        Image(systemName: icon)
                                //                                            .foregroundColor(.black)
                                //                                    } else {
                                //                                        Text(icon)
                                //                                            .font(.system(size: 16))
                                Image(name)
                                    .renderingMode(.template)
                                    .foregroundColor(selectedReligion == name ? .white : .primary)
                                //                                    }
                                
                                Text(name)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(selectedReligion == name ? .white : .primary)
                                    .fixedSize(horizontal: true, vertical: false) // Prevents truncation
                            }
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(selectedReligion == name ? Color("ButtonColor") : Color.clear)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(selectedReligion == name ? Color("ButtonColor") : .secondary, lineWidth: selectedReligion == name ? 2 : 1)
                            )
                        }
                    }
                }
            }
        }
    }
    
    
