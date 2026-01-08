//
//  NextButton.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 07/01/26.
//

import SwiftUI

struct PrimaryButton: View {
    
    var buttonText: String = "Next"
    
    var body: some View {
        Button(action: {}) {
            Text(buttonText)
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color("ButtonColor"))
                .cornerRadius(30)
        }
        .padding(.bottom, 20)
//        .padding(.horizontal, 25)

    }
}

#Preview{
    PrimaryButton()
}
