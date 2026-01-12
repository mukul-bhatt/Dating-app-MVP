//
//  WorkEducationView.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 09/01/26.
//


import SwiftUI

struct WorkEducationView: View {
    
    // MARK: - State Variables
    @ObservedObject var viewModel: ProfileViewModel
//    @State private var jobTitle: String = ""
//    @State private var education: String = ""
//    @State private var height: String = ""
//    
//    @State private var relationshipStatus: String = ""
//    @State private var lookingFor: String = ""
    
    // MARK: - Data Sources
    let relationshipOptions = [
        "Single", "Divorced", "Widowed", 
        "Separated", "It's Complicated"
    ]
    
    let lookingForOptions = [
        "Long-term partner", "New friends", 
        "Casual dating", "Not sure yet", 
        "Chat and see"
    ]
    
    // MARK: - Design Constants
    let backgroundColor = Color("BrandColor") // Brand Background
    let borderColor = Color.secondary // Solid black borders as per image
    
    var body: some View {
        ZStack {
            // Background
            backgroundColor.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    
                    // 1. Job Field
                    CustomTextField(
                        label: "Job",
                        placeholder: "What’s your 9-to-5... or passion project?",
                        text: $viewModel.jobTitle
                    )
                    
                    // 2. Education Field
                    CustomTextField(
                        label: "Education",
                        placeholder: "Where did you study or learn something cool?",
                        text: $viewModel.education
                    )
                    
                    // 3. Height Field
                    // Note: In a real app, this might be a scroll picker. 
                    // Visually, it's a text box in the design.
                    CustomTextField(
                        label: "Height",
                        placeholder: "", // Empty in screenshot
                        text: $viewModel.height
                    )
                    .keyboardType(.numbersAndPunctuation)
                    
                    // 4. Relationship Status Dropdown
                    CustomDropdown(
                        label: "Your current relationship status",
                        selection: $viewModel.relationshipStatus,
                        options: relationshipOptions
                    )
                    
                    // 5. Intent Dropdown
                    CustomDropdown(
                        label: "What are you hoping to find here?",
                        selection: $viewModel.lookingFor,
                        options: lookingForOptions
                    )
                    
                    Spacer()
                }
//                .padding(25)
            }
        }
        // Dismiss keyboard on tap
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

// MARK: - Reusable Components

// A. Standard Text Field Style
struct CustomTextField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.headline)
                .foregroundColor(.black)
            
            TextField(placeholder, text: $text)
                .padding()
                .frame(height: 50)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.secondary, lineWidth: 1)
                )
        }
    }
}

// B. Standard Dropdown Style
struct CustomDropdown: View {
    let label: String
    @Binding var selection: String
    let options: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.headline)
                .foregroundColor(.black)
            
            Menu {
                ForEach(options, id: \.self) { option in
                    Button(action: {
                        selection = option
                    }) {
                        Text(option)
                    }
                }
            } label: {
                HStack {
                    Text(selection.isEmpty ? "Select option" : selection)
                        .foregroundColor(selection.isEmpty ? .clear : .black)
                    Spacer()
                    Image(systemName: "arrowtriangle.down.fill")
                        .font(.caption)
                        .foregroundColor(.black)
                }
                .padding()
                .frame(height: 50)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.secondary, lineWidth: 1)
                )
            }
        }
    }
}

//#Preview {
//    WorkEducationView(viewModel: viewModel)
//}
