//
//  InputFieldSection.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 06/01/26.
//


import SwiftUI

struct Country {
    let name: String
    let code: String
    let dialCode: String
    let flag: String
}


struct PhoneInputFieldSection: View {
    
    @ObservedObject var viewModel: ProfileViewModel
    @State private var selectedCountry = Country(name: "India", code: "IN", dialCode: "91", flag: "🇮🇳")
    @State private var hasSelectedCountry = false
    
    let countries = [
        Country(name: "India", code: "IN", dialCode: "91", flag: "🇮🇳"),
           Country(name: "Russia", code: "RU", dialCode: "7", flag: "🇷🇺"),
           Country(name: "United Kingdom", code: "UK", dialCode: "44", flag: "🇬🇧"),
           Country(name: "United States", code: "US", dialCode: "1", flag: "🇺🇸")
    ]
    
    // Flag to switch layouts
    var isSingleLabel: Bool = false
    
//    @State private var phoneNumber: String = ""
    var isFocusedPhone: FocusState<Bool>.Binding
    
    // Style constants to match Figma
    let textColor = Color(red: 0.2, green: 0.1, blue: 0.15)
    let borderColor = Color.primary.opacity(0.6)
    
    var isPhoneNumberValid: Bool {
        viewModel.phoneNumber.count == 10 && viewModel.phoneNumber.allSatisfy(\.isNumber)
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
            if !isPhoneNumberValid && !viewModel.phoneNumber.isEmpty {
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
        Menu {
            ForEach(countries, id: \.code) { country in
                Button(action: {
                    selectedCountry = country
                    viewModel.selectedCountryDialCode = country.dialCode
                    hasSelectedCountry = true
                }) {
                    Text("\(country.flag) \(country.name) +\(country.dialCode)")
                }
            }
        } label: {
            HStack {
                Text("\(selectedCountry.code) +\(selectedCountry.dialCode)")
                    .foregroundColor(hasSelectedCountry ? .primary : .secondary)
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
    }
    
    // Reusable Phone Text Field UI
    private var phoneTextField: some View {
        TextField("", text: $viewModel.phoneNumber)
            .keyboardType(.numberPad)
            .padding()
            .frame(height: 55)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        isPhoneNumberValid || viewModel.phoneNumber.isEmpty ? borderColor : Color.red,
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

