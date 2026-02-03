//
//  ReportProfileView.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 29/01/26.
//


import SwiftUI
import PhotosUI

struct ReportProfileView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var path: NavigationPath
    let profile: DiscoverProfile
    @ObservedObject var viewModel: DiscoverViewModel
    // MARK: - State Variables
    @State private var selectedReason: String = "Hate speech or discrimination"
    @State private var additionalComments: String = ""
    @State private var isBlockingUser: Bool = false
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedImages: [UIImage] = []
    
    // Hardcoded list of reasons for the dropdown
    let reportReasons = [
       "Hate speech or discrimination", "Harassment or bullying", "Threats or violent behavior", "Sexual harassment", "Others"
    ]
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    // MARK: - Colors (Matching your design)
    let bgPink = AppTheme.backgroundPink // Light pink background
    let brandPink = AppTheme.foregroundPink // Dark pink for button
    
    var body: some View {
        ZStack {
            // 1. Background Color
            bgPink.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 2. Custom Header
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.black.opacity(0.7))
                            .padding(10)
                            .background(Color.black.opacity(0.05))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    
                    Spacer()
                    
                    Text("Report Profile")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    // Invisible view to balance the header centering
                    Color.clear.frame(width: 44, height: 44)
                }
                .padding()
                
                // 3. Scrollable Form Content
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        // Description Text
                        Text("Help us keep the community safe. Tell us what’s wrong with this profile")
                            .font(.subheadline)
                            .foregroundColor(.primary.opacity(0.8))
                            .padding(.bottom, 10)
                        
                        // --- Reason Dropdown ---
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Reason for Reporting")
                                .font(.headline)
                                .fontWeight(.medium)
                            
                            Menu {
                                ForEach(reportReasons, id: \.self) { reason in
                                    Button(reason) {
                                        selectedReason = reason
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedReason)
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Image(systemName: "arrowtriangle.down.fill")
                                        .font(.caption)
                                        .foregroundColor(.primary.opacity(0.7))
                                }
                                .padding()
                                .background(Color.clear)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.primary, lineWidth: 1)
                                )
                            }
                        }
                        .disabled(viewModel.isReporting)
                        
                        // --- Additional Comments ---
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Additional Comments (optional)")
                                .font(.headline)
                                .fontWeight(.medium)
                            
                            ZStack(alignment: .topLeading) {
                                if additionalComments.isEmpty {
                                    Text("Hate speech or discrimination") // Placeholder
                                        .foregroundColor(.secondary)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 16)
                                }
                                
                                TextEditor(text: $additionalComments)
                                    .scrollContentBackground(.hidden) // Removes default white bg
                                    .background(Color.clear)
                                    .padding(4)
                            }
                            .frame(height: 120)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.primary, lineWidth: 1)
                            )
                        }
                        .disabled(viewModel.isReporting)
                        
                        // --- Attach Proofs ---
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Attach Proofs (optional)")
                                .font(.headline)
                                .fontWeight(.medium)
                            
                            PhotosPicker(
                                selection: $selectedItems,
                                maxSelectionCount: 3,
                                matching: .images,
                                photoLibrary: .shared(),
                            ) {
                                VStack(spacing: 4) {
                                    Image(systemName: "plus")
                                        .font(.system(size: 24))
                                    Text("Upload")
                                        .font(.caption)
                                }
                                .foregroundColor(.black)
                                .frame(width: 80, height: 80)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.primary, lineWidth: 1)
                                )
                            }
                            .disabled(viewModel.isReporting)
                            .onChange(of: selectedItems) { oldItems, newItems in
                                
                                
                                Task{
                                    selectedItems.removeAll()
                                    selectedImages.removeAll()
                                    
                                    for item in newItems{
                                        if let data = try? await item.loadTransferable(type: Data.self) {
                                                        // 4. Convert Data to UIImage and add to our display array
                                                        if let uiImage = UIImage(data: data) {
                                                            selectedImages.append(uiImage)
                                                        }
                                                    }
                                    }
                                }
                            }
                            
                            // The Selected Images
                            LazyVGrid(columns: columns){
                                ForEach(0..<selectedImages.count, id: \.self) { index in
                                    ImageCell(image: selectedImages[index])
                                }
                            }
                        }
                        
                        // --- Block User Checkbox ---
                        Button(action: {
                            isBlockingUser.toggle()
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: isBlockingUser ? "checkmark.square.fill" : "square")
                                    .font(.system(size: 24))
                                    .foregroundColor(isBlockingUser ? brandPink : .gray.opacity(0.5))
                                    .background(Color.white) // Ensures the empty square has a white fill if needed
                                    .clipShape(RoundedRectangle(cornerRadius: 4))

                                Text("Block this user")
                                    .font(.body)
                                    .fontWeight(.medium)
                                    .foregroundColor(.primary)
                            }
                        }
                        .padding(.top, 10)
                        .disabled(viewModel.isReporting)
                        
//                        Spacer(minLength: 40)
                        
                        // --- Submit Button ---
                        Button(action: {
                            Task {
                                let success = await viewModel.reportProfile(
                                    ToUserId: profile.id,
                                    reason: selectedReason,
                                    comments: additionalComments,
                                    status: isBlockingUser ? "Blocked" : "Reported",
                                    images: selectedImages
                                )
                                
                                if success {
                                    await MainActor.run {
                                        // navigate to report is submitted screen only on success
                                        path.append(DiscoverRoute.Submit)
                                    }
                                }
                            }
                           
                        }) {
                            ZStack {
                                Text("Submit")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .opacity(viewModel.isReporting ? 0 : 1)
                                
                                if viewModel.isReporting {
                                    ProgressView()
                                        .tint(.white)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(brandPink)
                            .clipShape(Capsule())
                        }
                        .disabled(viewModel.isReporting)
                        .padding(.bottom, 20)
                        
                    }
                    .padding(.horizontal)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

//#Preview {
//    ReportProfileView(path: .constant(NavigationPath()),profile: DiscoverProfile.mock, viewModel: DiscoverViewModel())
//}

