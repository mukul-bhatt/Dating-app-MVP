//
//  LogoutView.swift
//  DatingAppFrontend
//
//  Created by Antigravity on 11/02/26.
//

import SwiftUI

struct LogoutView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var showLogoutView: Bool
    var body: some View {

        ZStack{
            Color.black.opacity(0.8).ignoresSafeArea()
            
            
            VStack{
                
          Spacer()
                VStack(spacing: 10) {
                Text("Logout")
                    .font(.headline)
                    .fontWeight(.bold)
                Text("You will need to login again to access your matches and messages. Are you sure you want to log out?")
                    .padding(.horizontal)
                
                HStack(spacing: 20){
                    
                    Button(action: {
                        withAnimation {
                            showLogoutView = false
                        }
                        
                    }) {
                        Text("Cancel")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                            .frame(width: 100, height: 50)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1.5)
                            )
                    }
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)

                    Button(action: {
                        // Logout action - perform logout
                        authViewModel.logout()
                    }) {
                        Text("Logout")
                            .font(.subheadline)
                            .foregroundColor(.red)
                            .frame(width: 100, height: 50)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.red.opacity(0.7), lineWidth: 1.5)
                            )
                    }
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                }
            }
            .padding()
            .background(.white)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)

            Spacer()
              }
        }
       
    }
}

//#Preview {
//    LogoutView()
//}
