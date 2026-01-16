//
//  RegisterWithUsView.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 06/01/26.
//

import SwiftUI

struct RegisterWithUsView: View {
    
    @ObservedObject var viewModel: ProfileViewModel
    
    @FocusState private var isFocused: Bool
    @FocusState private var isFocusedPhone: Bool
    
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 10){
                AuthHeader(
                    title: "Register with Us",
                    subtitle: "Please enter your details to get started"
                )
                
                
                VStack(spacing: 15) {
                    
                    LabeledTextField(
                        label: "Name",
                        placeholder: "",
                        text: $viewModel.name,
                        isFocused: $isFocused
                    )
                    
                    
                    PhoneInputFieldSection(isSingleLabel: true, isFocusedPhone: $isFocusedPhone)
                    GenderPickerView(selectedGender: $viewModel.selectedGender)
                    DatePickerView(date: $viewModel.dateOfBirth )
                }
                
                Text("We're about to send a One-Time Password to your contact information for secure login. Ensure your details are correct before proceeding")
                    .font(.caption2)
                
                Spacer()
                
                NavigationLink(destination: RegisterOtpVerificationView()){
                    PrimaryButton()
                }
            }
            .frame(maxWidth : .infinity, maxHeight: .infinity)
            .padding(.top, 30)
            .padding(.horizontal, 20)
            .background(Color("BrandColor"))
            .onTapGesture {
                isFocused = false
                isFocusedPhone = false
            }
        }
    }
 
}

//#Preview {
//    RegisterWithUsView(viewModel: <#ProfileViewModel#>)
//}
