//
//  WelcomeBackView.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 29/12/25.
//

//import SwiftUI
//
//struct WelcomeBackView: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}
//
//#Preview {
//    WelcomeBackView()
//}


import SwiftUI

struct WelcomeBackView: View {
    // State to hold the phone number input
    @State private var phoneNumber: String = ""
    
    // Custom Colors based on the image
    let backgroundColor = Color(red: 1.0, green: 0.92, blue: 0.95) // Light pink background
    let accentPink = Color(red: 0.9, green: 0.28, blue: 0.48) // The dark pink/magenta
    let textColor = Color(red: 0.2, green: 0.1, blue: 0.15) // Dark text color
    
    var body: some View {
        ZStack {
            // 1. Background Layer
            backgroundColor
                .ignoresSafeArea()
            
            VStack(spacing: 25) {
                
                // 2. Logo / Icon Section
                // Using a system symbol to mimic the heart cluster
                Image(systemName: "heart.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .foregroundStyle(accentPink)
                    .padding(.top, 40)
                
                // 3. Title Section
                VStack(spacing: 10) {
                    Text("Welcome Back!")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(textColor)
                    
                    Text("Please enter your phone number")
                        .font(.subheadline)
                        .foregroundColor(textColor.opacity(0.8))
                }
                .padding(.bottom, 20)
                
                // 4. Input Fields Section
                HStack(alignment: .bottom, spacing: 15) {
                    
                    // Country Code Dropdown
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Country")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        HStack {
                            Text("IN +91")
                                .fontWeight(.medium)
                                .foregroundColor(textColor)
                            Spacer()
                            Image(systemName: "arrowtriangle.down.fill")
                                .font(.caption)
                                .foregroundColor(textColor)
                        }
                        .padding()
                        .frame(width: 110, height: 55)
                        .background(Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(textColor, lineWidth: 1)
                        )
                    }
                    
                    // Phone Number Input
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Phone Number")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        TextField("", text: $phoneNumber)
                            .keyboardType(.numberPad)
                            .padding()
                            .frame(height: 55)
                            .background(Color.clear) // Matches the input bg color
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(textColor, lineWidth: 1)
                            )
                    }
                }
                
                // 5. Disclaimer Text
                Text("We're about to send a One-Time Password to your contact information for secure login. Ensure your details are correct before proceeding.")
                    .font(.footnote)
                    .foregroundColor(textColor.opacity(0.8))
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true) // Allows multiline wrap
                
                Spacer()
                
                // 6. Next Button
                Button(action: {
                    print("Next tapped")
                }) {
                    Text("Next")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(accentPink)
                        .cornerRadius(30) // Pill shape
                }
                .padding(.bottom, 20)
                
            }
            .padding(.horizontal, 25)
        }
        // Dismiss keyboard when tapping outside
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

// Preview Provider
struct WelcomeBackView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeBackView()
    }
}
