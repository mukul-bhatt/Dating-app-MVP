//
//  LoginOtpView.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 01/01/26.
//

import SwiftUI

struct LoginOtpView: View {

        @Binding var otp: [String]
        @FocusState private var focusedIndex: Int?

    let backgroundColor = Color(red: 1.0, green: 0.92, blue: 0.95)
        let textColor = Color(red: 0.2, green: 0.1, blue: 0.15)
        var body: some View {
            HStack(spacing: 12) {
                ForEach(0..<4, id: \.self) { index in
                    ZStack{
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .frame(minWidth: 66, maxWidth: .infinity, minHeight: 70, maxHeight: 70)
                            // Optional: Add subtle shadow for depth
                            .shadow(color: Color.black.opacity(0.03), radius: 2, x: 0, y: 2)
                    
                    TextField("", text: $otp[index])
                            .font(.title)
                            .fontWeight(.medium)
                            .foregroundColor(textColor)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
//                        .frame(width: 48, height: 56)
                        .cornerRadius(10)
                        .focused($focusedIndex, equals: index)
                        .onChange(of: otp[index]) { oldValue, newValue in
                            // Allow only one digit
                            if newValue.count > 1 {
                                otp[index] = String(newValue.last!)
                            }

                            // Move forward
                            if newValue.count == 1 {
                                focusedIndex = index < 5 ? index + 1 : nil
                            }

                            // Move backward
                            if newValue.isEmpty && index > 0 {
                                focusedIndex = index - 1
                            }
                        }
                        
                    }
                }
            }
            .onAppear {
                focusedIndex = 0
            }
        }

}

//#Preview {
//    LoginOtpView()
//}
