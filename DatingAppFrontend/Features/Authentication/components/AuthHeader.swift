//
//  Header.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 06/01/26.
//

import SwiftUI

struct AuthHeader: View {
    
    var title: String = "Welcome Back!"
    var subtitle: String = "Please enter your phone number"
    
    var body: some View {
        VStack(spacing: 8) {
            
            Image("appIcon")
                .resizable()
                .frame(width: 60, height: 60)

            
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)

            Text(subtitle)
                .font(.callout)
                .foregroundColor(.secondary)
        }.padding(.bottom, 20)
        
    }
}

#Preview{
    AuthHeader()
}
