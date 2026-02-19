//
//  EditProfileDetailsScreen.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 11/02/26.
//


import SwiftUI
import PhotosUI

@MainActor
struct EditProfileDetailsScreen: View {
    
    @ObservedObject var viewModel: ProfileViewModel
    @Binding var path: NavigationPath
    
    @StateObject private var editProfileViewModel = EditProfileViewModel()
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
                    
                    // 6. Sexuality
                    EditProfileLookupDropdown(
                        label: "Sexuality",
                        selectionId: $viewModel.sexualityId,
                        options: viewModel.sexualityOptions
                    )

                    
                    // 7. Your Pronouns
                    EditProfileLookupDropdown(
                        label: "Your Pronouns",
                        selectionId: $viewModel.pronounId,
                        options: viewModel.pronounOptions
                    )

                    // 8. Height
                    EditProfileTextField(
                        label: "Height",
                        text: $viewModel.height,
                        placeholder: "Enter height",
                        suffix: "cm"
                    )
                    .keyboardType(.numberPad)
                    
                    // Preferred Partner Sexuality
                    SexualitySection(viewModel: viewModel, title: "Preferred Partner's Sexuality", isMultiSelect: true, titleFont: .subheadline)

                    // MARK: - Next / Save Button
//                    Button(action: {
//                        viewModel.hasAttemptedSubmit = true
//                        if viewModel.isFormValid {
//                            Task {
//                                try? await viewModel.postFormDataToBackend()
//                            }
//                        }
//                    }) {
//                        Text("Next")
//                            .font(.headline)
//                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .background(Color.button)
//                            .cornerRadius(25)
//                    }
//                    .padding(.top, 10)

                    PrimaryButton() {
                        path.append(EditProfileRoutes.editProfile2)
                    }
                        
                }
                .padding(.horizontal)
            }
        }
        .onAppear{
            Task{
                if viewModel.religionOptions.isEmpty {
                    await viewModel.loadReligionOptions()
                }

                if viewModel.pronounOptions.isEmpty {
                    await viewModel.loadOptionsForPronouns()
                }

                if viewModel.sexualityOptions.isEmpty {
                    await viewModel.loadSexualityOptions()
                }
            }
            
        }
        .navigationTitle("Edit Profile")
    }
    
    // MARK: - Profile Image
    @MainActor
    var centerProfileImage: some View {
        HStack {
            Spacer()
            VStack(spacing: 12) {
                let selectedImage = editProfileViewModel.selectedProfilePicture
                let isUploading = editProfileViewModel.isUploadingProfilePicture
                let profilePictureURL = viewModel.profilePicture
                
                PhotosPicker(selection: $editProfileViewModel.profilePicturePickerItems,
                            maxSelectionCount: 1,
                            matching: .images,
                            photoLibrary: .shared()) {
                    ZStack(alignment: .bottomTrailing) {
                        // Profile Image
                        if let selectedImage = selectedImage {
                            // Show newly selected image
                            Image(uiImage: selectedImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 180, height: 180)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        } else if let url = URL(string: profilePictureURL) {
                            // Show existing profile image
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(width: 180, height: 180)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 180, height: 180)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                case .failure:
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 180, height: 180)
                                        .foregroundColor(.gray)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        } else {
                            // Placeholder when no image
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 180, height: 180)
                                .foregroundColor(.gray)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                        
                        // Loading overlay
                        if isUploading {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.black.opacity(0.5))
                                .frame(width: 180, height: 180)
                            
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(1.5)
                        }
                        
                        // Edit Icon - Always visible
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 44, height: 44)
                                .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 3)
                            
                            Circle()
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                .frame(width: 44, height: 44)
                            
                            Image(systemName: "camera.fill")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.black)
                        }
                        .offset(x: -10, y: -10)
                    }
                }
                .disabled(editProfileViewModel.isUploadingProfilePicture)
                
                Text("\(viewModel.name), \(calculateAge(from: viewModel.dateOfBirth))")
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            Spacer()
        }
        .onChange(of: editProfileViewModel.profilePicturePickerItems) { _, newItems in
            if !newItems.isEmpty {
                Task {
                    await editProfileViewModel.loadSelectedProfilePicture(profileViewModel: viewModel)
                }
            }
        }
        .alert("Upload Error", isPresented: .constant(editProfileViewModel.uploadError != nil)) {
            Button("OK") {
                editProfileViewModel.uploadError = nil
            }
        } message: {
            if let error = editProfileViewModel.uploadError {
                Text(error)
            }
        }
    }
    
    // Helper function to calculate age from date of birth
    private func calculateAge(from dateOfBirth: Date) -> String {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: dateOfBirth, to: Date())
        return "\(ageComponents.year ?? 0)"
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
                    .foregroundStyle(Color.primary)
                
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



#Preview {
    EditProfileDetailsScreen(viewModel: ProfileViewModel(), path: .constant(NavigationPath()))
}

