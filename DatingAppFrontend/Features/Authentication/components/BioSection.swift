//
//  BioSection.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 11/01/26.
//

import SwiftUI

  // Bio Section
    
    struct BioSection: View {
        
        @Binding var bio: String
        
        var body: some View {
            // 3. Bio Section
            VStack(alignment: .leading, spacing: 10) {
                Text("Bio")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                VStack(alignment: .trailing, spacing: 5) {
                    TextEditor(text: $bio)
                        .frame(height: 100)
                        .padding(10)
                        .scrollContentBackground(.hidden) // Required to change TextEditor bg
                        .background(Color.clear)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.secondary, lineWidth: 1)
                        )
                        .onChange(of: bio) { oldValue, newValue in
                            if newValue.count > 100 {
                                bio = String(newValue.prefix(100))
                            }
                        }
                    
                    Text("\(bio.count)/100")
                        .font(.caption)
                        .foregroundColor(.primary)
                }
            }
        }
    }
    
