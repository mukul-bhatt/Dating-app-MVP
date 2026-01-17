//
//  YourLocation.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 11/01/26.
//

import SwiftUI

  // Your location input field
     struct YourLocation : View {
        
         @ObservedObject var viewModel: ProfileViewModel
         

         var body : some View{
             VStack(alignment: .leading, spacing: 10){
                 
                 AddPicturesHeader(title: "Your location", subTitle: "Where are you right now? We will find matches nearby")
             
                 
                 TextField("Enter you location", text: $viewModel.location)
                     .padding()
                     .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.primary.opacity(0.5))
                     )
                     .onChange(of: viewModel.location) { oldValue, newValue in
                         // Filter out numbers
                         viewModel.location = newValue.filter{ !$0.isNumber }
                     }
                 
                 if viewModel.hasAttemptedSubmit, let errorMessage = viewModel.errorMessageForLocation {
                     HStack(spacing: 4) {
                         Image(systemName: "exclamationmark.circle.fill")
                         Text(errorMessage)
                     }
                     .font(.caption)
                     .foregroundColor(.red)
                     .transition(.opacity)
                 }
             }
                     
                 }
         }
     
