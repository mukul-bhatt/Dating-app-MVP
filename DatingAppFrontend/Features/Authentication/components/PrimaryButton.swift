//
//  NextButton.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 07/01/26.
//

import SwiftUI

//struct PrimaryButton: View {
//    
//    var buttonText: String = "Next"
//    
//    var body: some View {
//        Button(action: {}) {
//            Text(buttonText)
//                .font(.headline)
//                .foregroundColor(.white)
//                .frame(maxWidth: .infinity)
//                .padding()
//                .background(Color("ButtonColor"))
//                .cornerRadius(30)
//        }
//        .padding(.bottom, 20)
////        .padding(.horizontal, 25)
//
//    }
//}

struct PrimaryButton: View {
    var buttonText: String = "Next"
    var action: (() -> Void)? = nil  // Optional action
    var isDiabled: Bool = false
    
    var body: some View {
        if let action = action {
            // If action provided, use Button
            Button(action: action) {
                buttonContent
            }
            .padding(.bottom, 20)
            
        } else {
            // If no action, just return the styled view (for NavigationLink)
            buttonContent
                .padding(.bottom, 20)
        }
    }
    
    // Extracted button styling
    private var buttonContent: some View {
        Text(buttonText)
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color("ButtonColor"))
            .cornerRadius(30)
    }
}
#Preview{
    PrimaryButton()
}
