//
//  GenderPickerView.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 06/01/26.
//


import SwiftUI

struct GenderPickerView: View {
    @Binding var selectedGender: String
    @State private var isExpanded: Bool = false
    
    let genderOptions = ["Male", "Female", "Other", "Prefer not to say"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Gender")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Menu {
                ForEach(genderOptions, id: \.self) { option in
                    Button(action: {
                        selectedGender = option
                    }) {
                        Text(option)
                    }
                }
            } label: {
                HStack {
                    Text(selectedGender.isEmpty ? "Select one option" : selectedGender)
                        .foregroundColor(selectedGender.isEmpty ? .secondary : .primary)
                        .font(.system(size: 16))
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .foregroundColor(.primary)
                        .font(.system(size: 14, weight: .medium))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.primary.opacity(0.5))
                )
            }
        }
    }
}

// Preview
//struct GenderPickerView_Previews: PreviewProvider {
//    static var previews: some View {
//        GenderPickerView()
//            .padding()
//            .previewLayout(.sizeThatFits)
//    }
//}
