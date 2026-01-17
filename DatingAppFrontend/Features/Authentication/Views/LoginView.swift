//
//  LoginView.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 26/12/25.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @FocusState private var isFocused: Bool
    @FocusState private var isFocusedPhone: Bool
    
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 30) {
                
                AuthHeader()
                
                PhoneInputFieldSection(viewModel: viewModel, isSingleLabel: true, isFocusedPhone: $isFocusedPhone)
                
                Spacer()
                
                NavigationLink(destination: LoginOtpVerificationView(viewModel: viewModel)){
                    PrimaryButton()
                }
                
            }
            .padding(.top, 30)
            .padding(.horizontal)
            .background(Color("BrandColor"))
        }
    }
}



//#Preview {
//    LoginView()
    // Preview in dark mode as well
//    LoginView().environment(\.colorScheme, .dark)
//}


struct InputFieldSection : View {
    
    @State private var phoneNumber: String = ""
    
    var isphoneNumberValid : Bool {
        phoneNumber.count == 10 && phoneNumber.allSatisfy(\.isNumber)
    }
    
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
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.primary.opacity(0.5), lineWidth: 1)
                    )
                }
                
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Phone Number")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    TextField("", text: $phoneNumber)
                        .keyboardType(.numberPad)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(
                                    isphoneNumberValid || phoneNumber.isEmpty ? Color.primary.opacity(0.5) : Color.red
                                )
                        )
                    
                                       
                }
                
                
                
                
                
            }
            .frame(height: 48)
            
            
            VStack{
                
                HStack{
                    
                    Spacer()
                    
                    if !isphoneNumberValid && !phoneNumber.isEmpty {
                        Text("Phone Number must be exactly 10 digits")
                            .font(.caption2)
                            .foregroundColor(.red)
                    }
                }
                
                
                Text("We are about to send a one time password to your contact information for secure login. Ensure your details are correct before proceeding")
                    .font(.footnote)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)

            }
            
            
            
            
        }
    }
}
