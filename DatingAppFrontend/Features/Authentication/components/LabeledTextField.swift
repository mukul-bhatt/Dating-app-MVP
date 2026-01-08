//
//  LabeledTextField.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 06/01/26.
//

import SwiftUI

struct LabeledTextField: View {

    let label: String
    let placeholder: String
    @Binding var text: String
    var isFocused: FocusState<Bool>.Binding
    @State private var hasStartedTyping = false
    
    // Name Validation
    var isValidUserName: Bool {
         let hasValidLength = text.count >= 3 && text.count <= 20
        let hasNoNumbers = text.allSatisfy{ character in
            !character.isNumber
            
        }
        
        return hasValidLength && hasNoNumbers
    }
    

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)

            TextField(placeholder, text: $text)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke((!hasStartedTyping || isValidUserName) ? Color.primary.opacity(0.5) : .red.opacity(0.5))
                )
                .onChange(of: text){ oldValue, newValue in
                    if !newValue.isEmpty{
                        hasStartedTyping = true
                    }
                    
                }
                .focused(isFocused)
            
            if !isValidUserName && hasStartedTyping {
                withAnimation {
                    HStack(spacing: 4) {
                        Image(systemName: "exclamationmark.circle.fill")
                        Text("Username must be 3-20 characters with no numbers")
                    }
                    .font(.caption)
                    .foregroundColor(.red)
                }
            }
        }
    }
}


