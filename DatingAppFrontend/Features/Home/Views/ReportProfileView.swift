//
//  ReportProfileView.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 29/01/26.
//


import SwiftUI

struct ReportProfileView: View {
    @Environment(\.dismiss) var dismiss
    
    // MARK: - State Variables
    @State private var selectedReason: String = "Hate speech or discrimination"
    @State private var additionalComments: String = ""
    @State private var isBlockingUser: Bool = false
    
    // Hardcoded list of reasons for the dropdown
    let reportReasons = [
        "Hate speech or discrimination",
        "Fake profile",
        "Harassment or bullying",
        "Inappropriate content",
        "Scam or fraud"
    ]
    
    // MARK: - Colors (Matching your design)
    let bgPink = AppTheme.backgroundPink // Light pink background
    let brandPink = AppTheme.foregroundPink // Dark pink for button
    
    var body: some View {
        ZStack {
            // 1. Background Color
            bgPink.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 2. Custom Header
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.black.opacity(0.7))
                            .padding(10)
                            .background(Color.black.opacity(0.05))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    
                    Spacer()
                    
                    Text("Report Profile")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    // Invisible view to balance the header centering
                    Color.clear.frame(width: 44, height: 44)
                }
                .padding()
                
                // 3. Scrollable Form Content
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        // Description Text
                        Text("Help us keep the community safe. Tell us what’s wrong with this profile")
                            .font(.subheadline)
                            .foregroundColor(.primary.opacity(0.8))
                            .padding(.bottom, 10)
                        
                        // --- Reason Dropdown ---
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Reason for Reporting")
                                .font(.headline)
                                .fontWeight(.medium)
                            
                            Menu {
                                ForEach(reportReasons, id: \.self) { reason in
                                    Button(reason) {
                                        selectedReason = reason
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedReason)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Image(systemName: "arrowtriangle.down.fill")
                                        .font(.caption)
                                        .foregroundColor(.primary.opacity(0.7))
                                }
                                .padding()
                                .background(Color.clear)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.primary, lineWidth: 1)
                                )
                            }
                        }
                        
                        // --- Additional Comments ---
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Additional Comments (optional)")
                                .font(.headline)
                                .fontWeight(.medium)
                            
                            ZStack(alignment: .topLeading) {
                                if additionalComments.isEmpty {
                                    Text("Hate speech or discrimination") // Placeholder
                                        .foregroundColor(.secondary)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 16)
                                }
                                
                                TextEditor(text: $additionalComments)
                                    .scrollContentBackground(.hidden) // Removes default white bg
                                    .background(Color.clear)
                                    .padding(4)
                            }
                            .frame(height: 120)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.primary, lineWidth: 1)
                            )
                        }
                        
                        // --- Attach Proofs ---
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Attach Proofs (optional)")
                                .font(.headline)
                                .fontWeight(.medium)
                            
                            Button(action: {
                                // Action to open image picker would go here
                            }) {
                                VStack(spacing: 4) {
                                    Image(systemName: "plus")
                                        .font(.system(size: 24))
                                    Text("Upload")
                                        .font(.caption)
                                }
                                .foregroundColor(.black)
                                .frame(width: 80, height: 80)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.primary, lineWidth: 1)
                                )
                            }
                        }
                        
                        // --- Block User Checkbox ---
                        Button(action: {
                            isBlockingUser.toggle()
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: isBlockingUser ? "checkmark.square.fill" : "square")
                                    .font(.system(size: 24))
                                    .foregroundColor(isBlockingUser ? brandPink : .gray.opacity(0.5))
                                    .background(Color.white) // Ensures the empty square has a white fill if needed
                                    .clipShape(RoundedRectangle(cornerRadius: 4))

                                Text("Block this user")
                                    .font(.body)
                                    .fontWeight(.medium)
                                    .foregroundColor(.black)
                            }
                        }
                        .padding(.top, 10)
                        
                        Spacer(minLength: 40)
                        
                        // --- Submit Button ---
                        Button(action: {
                            print("Report Submitted")
                        }) {
                            Text("Submit")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(brandPink)
                                .clipShape(Capsule())
                        }
                        .padding(.bottom, 20)
                        
                    }
                    .padding(.horizontal)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    ReportProfileView()
}
