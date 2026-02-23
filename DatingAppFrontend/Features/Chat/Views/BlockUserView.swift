//
//  BlockUserView.swift
//  DatingAppFrontend
//
//  Created by Antigravity on 23/02/26.
//

import SwiftUI

struct BlockUserView: View {
    let userName: String
    @Binding var isPresented: Bool
    @State private var reportAccount = false
    var onBlock: (Bool) -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    isPresented = false
                }
            
            VStack(spacing: 24) {
                // Prohibited Icon
//                Image(systemName: "prohibited")
                Image(systemName: "circle.slash")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 48, height: 48)
                    .foregroundColor(AppTheme.foregroundPink)
                    .padding(.top, 8)
                // Title
                Text("Block \(userName) ?")
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                
                // Description
                Text("This person won't be able to message or call you. They won't know you blocked or reported them.")
                    .font(.system(size: 18))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(4)
                    .padding(.horizontal, 4)
                
                // Report Account row
                Button(action: {
                    reportAccount.toggle()
                }) {
                    HStack(spacing: 16) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 1)
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 24, height: 24)
                            
                            if reportAccount {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(AppTheme.foregroundPink)
                            }
                        }
                        
                        Text("Report Account")
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                        
                        Spacer()
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.vertical, 8)
                
                // Buttons
                HStack(spacing: 32) {
                    Spacer()
                    
                    Button("Cancel") {
                        isPresented = false
                    }
                    .font(.system(size: 20))
                    .foregroundColor(.black)
                    
                    Button("Block") {
                        onBlock(reportAccount)
                        isPresented = false
                    }
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
                }
                .padding(.top, 16)
            }
            .padding(32)
            .background(Color.white)
            .cornerRadius(32)
            .padding(.horizontal, 24)
            .shadow(color: .black.opacity(0.1), radius: 20)
        }
    }
}

#Preview {
    BlockUserView(userName: "Alex", isPresented: .constant(true), onBlock: { _ in })
}
