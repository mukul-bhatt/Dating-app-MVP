//
//  EditProfileDetailsScreen.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 11/02/26.
//


import SwiftUI

struct EditProfileDetailsScreen: View {
    
    @ObservedObject var viewModel: ProfileViewModel
    @State private var showDatePicker = false
    
    var body: some View {
        ZStack {
            AppTheme.backgroundPink.ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Profile Image
                    centerProfileImage
                    
                    // Progress Steps
                    ProgressIndicator(currentStep: 0)
                    
                    // MARK: - Form Fields
                    
                    // 1. Name
                    EditProfileTextField(
                        label: "Name",
                        text: $viewModel.name,
                        placeholder: "Enter your name"
                    )
                    
                    // 2. Date of Birth
                    EditProfileDateField(
                        label: "Date of birth",
                        date: $viewModel.dateOfBirth,
                        hasSelectedDate: $viewModel.hasSelectedDate
                    )
                    
                    // 3. City
                    EditProfileTextField(
                        label: "City",
                        text: $viewModel.location,
                        placeholder: "Enter your city",
//                        isDropdown: true
                    )
                    
                    // 4. Gender

                    EditProfileDropdown(
                        label: "Gender",
                        selection: $viewModel.selectedGender,
                        options: ["Male", "Female", "Other", "Prefer not to say"]
                    )
                    
                    // 5. Religion
                    EditProfileLookupDropdown(
                        label: "Religion",
                        selectionId: $viewModel.selectedReligionId,
                        options: viewModel.religionOptions
                    )
                    .onAppear {
                        if viewModel.religionOptions.isEmpty {
                            Task { await viewModel.loadReligionOptions() }
                        }
                    }
                    
                    // 6. Sexuality
                    EditProfileLookupDropdown(
                        label: "Sexuality",
                        selectionId: $viewModel.sexualityId,
                        options: viewModel.sexualityOptions
                    )
                    .onAppear {
                        if viewModel.sexualityOptions.isEmpty {
                            Task { await viewModel.loadSexualityOptions() }
                        }
                    }
                    
                    // 7. Your Pronouns
                    EditProfileLookupDropdown(
                        label: "Your Pronouns",
                        selectionId: $viewModel.pronounId,
                        options: viewModel.pronounOptions
                    )
                    .onAppear {
                        if viewModel.pronounOptions.isEmpty {
                            Task { await viewModel.loadOptionsForPronouns() }
                        }
                    }
                    
                    // 8. Height
                    EditProfileTextField(
                        label: "Height",
                        text: $viewModel.height,
                        placeholder: "Enter height",
                        suffix: "cm"
                    )
                    .keyboardType(.numberPad)
                    
                    // MARK: - Next / Save Button
                    Button(action: {
                        viewModel.hasAttemptedSubmit = true
                        if viewModel.isFormValid {
                            Task {
                                try? await viewModel.postFormDataToBackend()
                            }
                        }
                    }) {
                        Text("Next")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0.85, green: 0.25, blue: 0.45))
                            .cornerRadius(25)
                    }
                    .padding(.top, 10)
                }
                .padding(.horizontal)
            }
        }
        .onAppear{
            Task{
                await viewModel.loadLookingForOptions()
                await viewModel.loadOptionsForPronouns()
                await viewModel.loadReligionOptions()
                await viewModel.loadSexualityOptions()
            }
            
        }
        .navigationTitle("Edit Profile")
    }
    
    // MARK: - Profile Image
    var centerProfileImage: some View {
        HStack {
            Spacer()
            VStack(spacing: 12) {
                Image("NiaSharma")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 180, height: 180)
                    .cornerRadius(20)
                
                Text("Nia Sharma, 23")
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            Spacer()
        }
    }
}

// MARK: - Reusable Edit Profile Field Components

/// Simple text input field with label
struct EditProfileTextField: View {
    let label: String
    @Binding var text: String
    var placeholder: String = ""
    var isDropdown: Bool = false
    var suffix: String? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack {
                TextField(placeholder, text: $text)
                    .font(.body)
                
                if let suffix = suffix {
                    Text(suffix)
                        .foregroundColor(.gray)
                }
                
                if isDropdown {
                    Image(systemName: "chevron.down")
                        .font(.caption)
                        .foregroundColor(.black)
                }
            }
            .padding()
            .background(Color.clear)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.black.opacity(0.5), lineWidth: 1)
            )
        }
    }
}

/// Date picker field with calendar icon
struct EditProfileDateField: View {
    let label: String
    @Binding var date: Date
    @Binding var hasSelectedDate: Bool
    @State private var showPicker = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Button(action: { showPicker = true }) {
                HStack {
                    Text(hasSelectedDate ? formattedDate(date) : "DD/MM/YYYY")
                        .font(.body)
                        .foregroundColor(hasSelectedDate ? .black : .gray)
                    Spacer()
                    Image(systemName: "calendar")
                        .foregroundColor(.black.opacity(0.6))
                }
                .padding()
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.black.opacity(0.5), lineWidth: 1)
                )
            }
            .sheet(isPresented: $showPicker) {
                NavigationStack {
                    VStack {
                        HStack {
                            Text("Select your Date of Birth")
                                .font(.headline)
                            Spacer()
                        }
                        .padding()
                        
                        DatePicker(
                            "",
                            selection: $date,
                            in: ...Date(),
                            displayedComponents: [.date]
                        )
                        .datePickerStyle(.graphical)
                        .padding()
                        .toolbar {
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Done") {
                                    showPicker = false
                                    hasSelectedDate = true
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(AppTheme.backgroundPink)
                }
            }
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
}

/// Dropdown field for simple String arrays (e.g. Gender)
struct EditProfileDropdown: View {
    let label: String
    @Binding var selection: String
    let options: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Menu {
                ForEach(options, id: \.self) { option in
                    Button(action: { selection = option }) {
                        Text(option)
                    }
                }
            } label: {
                HStack {
                    Text(selection.isEmpty ? "Select option" : selection)
                        .font(.body)
                        .foregroundColor(selection.isEmpty ? .gray : .black)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.caption)
                        .foregroundColor(.black)
                }
                .padding()
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.black.opacity(0.5), lineWidth: 1)
                )
            }
        }
    }
}

/// Dropdown field for LookUpOption arrays (e.g. Religion, Sexuality, Pronouns)
struct EditProfileLookupDropdown: View {
    let label: String
    @Binding var selectionId: Int?
    let options: [LookUpOption]
    
    private var selectedName: String {
        if let id = selectionId, let match = options.first(where: { $0.id == id }) {
            return match.name
        }
        return "Select option"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Menu {
                ForEach(options) { option in
                    Button(action: { selectionId = option.id }) {
                        Text(option.name)
                    }
                }
            } label: {
                HStack {
                    Text(selectedName)
                        .font(.body)
                        .foregroundColor(selectionId == nil ? .gray : .black)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.caption)
                        .foregroundColor(.black)
                }
                .padding()
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.black.opacity(0.5), lineWidth: 1)
                )
            }
        }
    }
}

// MARK: - Progress Indicator
struct ProgressIndicator: View {
    let currentStep: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<3, id: \.self) { index in
                Capsule()
                    .fill(index == currentStep ? Color(red: 0.85, green: 0.25, blue: 0.45) : Color.black.opacity(0.7))
                    .frame(height: 4)
            }
        }
        .padding(.vertical, 10)
    }
}

#Preview {
    EditProfileDetailsScreen(viewModel: ProfileViewModel())
}
