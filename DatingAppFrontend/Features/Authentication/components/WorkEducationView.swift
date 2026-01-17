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
    
    // MARK: - Data Sources
//    let relationshipOptions = [
//        "Single", "Divorced", "Widowed", 
//        "Separated", "It's Complicated"
//    ]
//    
//    let lookingForOptions = [
//        "Long-term partner", "New friends", 
//        "Casual dating", "Not sure yet", 
//        "Chat and see"
//    ]
    
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
                        text: $viewModel.jobTitle,
                        errorMessage: viewModel.errorMessageForJobTitleField,
                        viewModel: viewModel

                    ).onSubmit {
                        _ = viewModel.isValidJobTitle
                    }
                    
                    // 2. Education Field
                    CustomTextField(
                        label: "Education",
                        placeholder: "Where did you study or learn something cool?",
                        text: $viewModel.education,
                        errorMessage: viewModel.errorMessageForEducationField,
                        viewModel: viewModel

                        
                    ).onSubmit {
                        _ = viewModel.isValidEducation
                    }
                    
                    // 3. Height Field
                    CustomTextField(
                        label: "Height",
                        placeholder: "", // Empty in screenshot
                        text: $viewModel.height,
                        subScriptForHeight: true,
                        isNumericOnly: true,
                        errorMessage: viewModel.heightValidationMessage,
                        viewModel: viewModel
                    )
                    .keyboardType(.numbersAndPunctuation)
                    .onSubmit {
                       let _ = viewModel.isValidHeight
                    }
                    
                    
                    // 4. Relationship Status Dropdown
                    CustomDropdown(
                        label: "Your current relationship status",
                        selection: $viewModel.relationshipStatusId,
                        options: viewModel.relationshipStatusOptions,
                        errorMessage: viewModel.errorMessageForRelationshipStatus,
                        viewModel: viewModel
                        
                    )
                    
                    // 5. Intent Dropdown
                    CustomDropdown(
                        label: "What are you hoping to find here?",
                        selection: $viewModel.lookingForId,
                        options: viewModel.lookingForOptions,
                        errorMessage: viewModel.errorMessageForLookingForField,
                        viewModel: viewModel
                        
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
        .onAppear {
            Task {
                await viewModel.loadRelationshipStatusOptions()
                await viewModel.loadLookingForOptions()
            }
        }
    }
}

// MARK: - Reusable Components

// A. Standard Text Field Style
struct CustomTextField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var subScriptForHeight: Bool = false
    var isNumericOnly: Bool = false
    var errorMessage: String?
    var viewModel: ProfileViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.headline)
                .foregroundColor(.primary)
            
            HStack{
                TextField(placeholder, text: $text)
                if subScriptForHeight {
                    Text("Cm").foregroundStyle(Color.white)
                }
            }
                .padding()
                .frame(height: 50)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.secondary, lineWidth: 1)
                )
                .onChange(of: text){ oldValue, newValue in
                    if isNumericOnly{
                        text = newValue.filter{$0.isWholeNumber}
                    }
                    
                  
                }
            
            
            if viewModel.hasAttemptedSubmit, let errorMessage = errorMessage {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.circle.fill")
                    Text(errorMessage)
                }
                .font(.caption)
                .foregroundColor(.red)
                
            }
            
        }
    }
}

// B. Standard Dropdown Style
struct CustomDropdown: View {
    let label: String
    @Binding var selection: Int?
    let options: [LookUpOption]
    var errorMessage: String?
    var viewModel: ProfileViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.headline)
                .foregroundColor(.primary)
            
            Menu {
                ForEach(options) { option in
                    Button(action: {
                        selection = option.id
                    }) {
                        Text(option.name)
                    }
                }
            } label: {
                HStack {
                    let selectedName: String = {
                        if let id = selection, let match = options.first(where: { $0.id == id }) {
                            return match.name
                        } else {
                            return "Select option"
                        }
                    }()
                    Text(selectedName)
                        .foregroundColor((selection == nil) ? .secondary : .primary)
                    Spacer()
                    Image(systemName: "arrowtriangle.down.fill")
                        .font(.caption)
                        .foregroundColor(.primary)
                }
                .padding()
                .frame(height: 50)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.secondary, lineWidth: 1)
                )
            }
            
            if viewModel.hasAttemptedSubmit, let errorMessage = errorMessage {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.circle.fill")
                    Text(errorMessage)
                }
                .font(.caption)
                .foregroundColor(.red)
            }
        }
    }
}

//#Preview {
//    WorkEducationView(viewModel: viewModel)
//}
