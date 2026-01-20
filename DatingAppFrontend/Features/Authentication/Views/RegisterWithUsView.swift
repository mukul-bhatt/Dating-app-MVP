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
    
    @State private var navigateToOtpVerificationScreen: Bool = false
    @State private var hasClickedNextButton = false
    
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
                    
                    
                    PhoneInputFieldSection(viewModel:viewModel, isSingleLabel: true, isFocusedPhone: $isFocusedPhone)
                    GenderPickerView(selectedGender: $viewModel.selectedGender)
                    DatePickerView(date: $viewModel.dateOfBirth, hasSelectedDate: $viewModel.hasSelectedDate )
                }
                
                Text("We're about to send a One-Time Password to your contact information for secure login. Ensure your details are correct before proceeding")
                    .font(.caption2)
                
                if hasClickedNextButton && !viewModel.isRegisterFormValid{
                    withAnimation {
                        HStack(spacing: 4) {
                            Image(systemName: "exclamationmark.circle.fill")
                            Text("Please Fill all the fields before proceeding")
                        }
                        .font(.caption)
                        .foregroundColor(.red)
                    }
                    
                }
                Spacer()
                
                PrimaryButton(){
                    
                    if viewModel.isRegisterFormValid{
                        // Call register otp endpoint
                        Task{
                            do{
                                try await viewModel.callBackendWithRegisterEndpoint()
                            }catch{
                                print("Error is : \(error)")
                            }
                        }
                        
                        navigateToOtpVerificationScreen = true
                    }else{
                        hasClickedNextButton = true
                        
                    }
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
            
        }.navigationDestination(isPresented: $navigateToOtpVerificationScreen) {
            RegisterOtpVerificationView(viewModel: viewModel)
        }
    }
 
}

//#Preview {
//    RegisterWithUsView(viewModel: <#ProfileViewModel#>)
//}
