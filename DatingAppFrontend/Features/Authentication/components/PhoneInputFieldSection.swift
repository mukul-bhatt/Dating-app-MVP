//
//  InputFieldSection.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 06/01/26.
//


import SwiftUI

struct PhoneInputFieldSection: View {
    // Flag to switch layouts
    var isSingleLabel: Bool = false
    
    @State private var phoneNumber: String = ""
    var isFocusedPhone: FocusState<Bool>.Binding
    
    // Style constants to match Figma
    let textColor = Color(red: 0.2, green: 0.1, blue: 0.15)
    let borderColor = Color.primary.opacity(0.6)
    
    var isPhoneNumberValid: Bool {
        phoneNumber.count == 10 && phoneNumber.allSatisfy(\.isNumber)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            // Layout A: Single Label (Used in RegisterView)
            if isSingleLabel {
                Text("Phone Number")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 12) {
                    countryPicker
                    phoneTextField
                }
            }
            // Layout B: Double Label (Used in other screens)
            else {
                HStack(alignment: .bottom, spacing: 12) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Country")
                            .font(.caption)
                            .foregroundColor(.gray)
                        countryPicker
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Phone Number")
                            .font(.caption)
                            .foregroundColor(.gray)
                        phoneTextField
                    }
                }
            }
            
            // Error Message
            if !isPhoneNumberValid && !phoneNumber.isEmpty {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.circle.fill")
                    Text("Phone Number must be exactly 10 digits")
                }.font(.caption)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }
    
    // Reusable Country Picker UI
    private var countryPicker: some View {
        HStack {
            Text("IN +91")
                .foregroundColor(.secondary)
            Spacer()
            Image(systemName: "arrowtriangle.down.fill")
                .font(.system(size: 10))
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(width: 100, height: 55)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(borderColor, lineWidth: 1)
        )
    }
    
    // Reusable Phone Text Field UI
    private var phoneTextField: some View {
        TextField("", text: $phoneNumber)
            .keyboardType(.numberPad)
            .padding()
            .frame(height: 55)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        isPhoneNumberValid || phoneNumber.isEmpty ? borderColor : Color.red,
                        lineWidth: 1
                    )
            )
            .focused(isFocusedPhone)
    }
}

//#Preview {
//    VStack(spacing: 40) {
//        PhoneInputFieldSection(isSingleLabel: true, ) // Figma Style
//            .padding()
//        PhoneInputFieldSection(isSingleLabel: false) // Original Style
//            .padding()
//    }
//}

