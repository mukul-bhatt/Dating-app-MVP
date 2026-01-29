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
//    @State private var navigateToNextScreen: Bool = false
//    @State private var navigateToSplashScreen: Bool = false
    @State private var hasClickedNextButton: Bool = false
    var isPhoneNumberValid: Bool {
        viewModel.phoneNumber.count == 10 && !viewModel.phoneNumber.isEmpty
    }
    @Binding var path: NavigationPath

    var body: some View {
            VStack(spacing: 30) {
                
                AuthHeader()
                
                PhoneInputFieldSection(viewModel: viewModel, isSingleLabel: true, isFocusedPhone: $isFocusedPhone)
                
                Spacer()
                
                if hasClickedNextButton && !isPhoneNumberValid{
                    withAnimation {
                        HStack(spacing: 4) {
                            Image(systemName: "exclamationmark.circle.fill")
                            Text("Please fill the phone number field")
                        }
                        .font(.caption)
                        .foregroundColor(.red)
                    }
                    
                }
                
                PrimaryButton(){
                    
                    if isPhoneNumberValid{
                        // Call register otp endpoint
                        Task{
                            do{
                                let response = try await viewModel.callBackendWithRegisterEndpoint()
                        
//                                print("response: ",response)
//                                 If the user is a registered User, only then login, otherwise send them to register
                                            if response.isNewUser == false{
                                                await MainActor.run {
                                                path.append(Route.loginOtp)
                                                }
                                                        }else{
                                                // SHow an alert to this user that this is a first time user- so this user should Register first
                        //                                 path = NavigationPath()
                                            path.append(Route.register)
                                                    }
                        
                            }catch{
                                print("Error is : \(error)")
                            }
                        }
//                        path.append(Route.loginOtp)
                        
                    }else{
                        hasClickedNextButton = true
                    }
                }
                
            }
            .padding(.top, 30)
            .padding(.horizontal)
            .background(Color("BrandColor"))
        
    }
}




