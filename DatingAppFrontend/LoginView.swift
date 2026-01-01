//
//  LoginView.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 26/12/25.
//

import SwiftUI

struct LoginView: View {
    
    @State private var nameComponents = PersonNameComponents()
    
    
    
    var body: some View {
        VStack(spacing: 30) {
            
            Header()
            
            InputFieldSection()
            
            Spacer()
            
            NextButton()
            
        }
        .padding(.top, 30)
        .padding(.horizontal)
        .background(Color.pink.opacity(0.1))
        
    }
}



#Preview {
    LoginView()
}


struct NextButton: View {
    var body: some View {
        Button(action: {}) {
            Text("Next")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.pink)
                .cornerRadius(30)
        }
        .padding(.bottom, 20)

    }
}

struct Header: View {
    var body: some View {
        VStack(spacing: 8) {
            
            Image(systemName:"heart.circle.fill")
                .resizable()
                .frame(width: 60, height: 60)

            
            Text("Welcome Back!")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Please enter your phone number")
                .font(.callout)
                .foregroundColor(.secondary)
        }.padding(.bottom, 20)
        
    }
}


struct InputFieldSection : View {
    var body: some View {
        VStack(spacing: 30) {
            HStack(spacing: 12) {
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Country")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    HStack {
                        Text("IN +91")
                        Spacer()
                        Image(systemName: "chevron.down")
                    }
                    .padding()
                    .frame(width: 110)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.4))
                    )
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Phone Number")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    TextField("", text: .constant(""))
                        .keyboardType(.numberPad)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.4))
                        )
                }
                
                
                
                
            }
            .frame(height: 48)
            
            Text("We are about to send a one time password to your contact information for secure login. Ensure your details are correct before proceeding")
                .font(.footnote)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            
            
        }
    }
}
