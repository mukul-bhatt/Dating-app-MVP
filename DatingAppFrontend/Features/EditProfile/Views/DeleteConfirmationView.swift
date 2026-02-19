//
//  DeleteConfirmationView.swift
//  DatingAppFrontend
//
//  Created by Antigravity on 11/02/26.
//

import SwiftUI

struct DeleteConfirmationView: View {
    @Binding var showDeleteConfirmation: Bool
    var onDelete: () -> Void = {}
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8).ignoresSafeArea()
            
            VStack {
                Spacer()
                
                VStack(spacing: 20) {
                    Text("Delete Account")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Text("Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently removed.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    HStack(spacing: 20) {
                        Button(action: {
                            withAnimation {
                                showDeleteConfirmation = false
                            }
                        }) {
                            Text("Cancel")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                                .frame(width: 120, height: 50)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray.opacity(0.5), lineWidth: 1.5)
                                )
                        }
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                        
                        Button(action: {
                            onDelete()
                        }) {
                            Text("Delete")
                                .font(.subheadline)
                                .foregroundColor(.red)
                                .frame(width: 120, height: 50)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.red.opacity(0.7), lineWidth: 1.5)
                                )
                        }
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                    }
                }
                .padding(.vertical, 30)
                .padding(.horizontal, 20)
                .background(Color.white)
                .cornerRadius(24)
                .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
                .padding(.horizontal, 30)
                
                Spacer()
            }
        }
    }
}

#Preview {
    DeleteConfirmationView(showDeleteConfirmation: .constant(true))
}
