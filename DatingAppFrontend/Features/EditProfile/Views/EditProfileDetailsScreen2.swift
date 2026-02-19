//
//  EditProfileDetailsScreen2.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 11/02/26.
//

import SwiftUI

struct EditProfileDetailsScreen2: View {
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    @ObservedObject var viewModel: ProfileViewModel
    @Binding var path: NavigationPath
    
    var body: some View {
        ZStack {
            AppTheme.backgroundPink.ignoresSafeArea()
            
            VStack {
                ProgressIndicator(currentStep: 1)
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        BioSection(viewModel: viewModel, isFromEditProfile: true)
                        
                        AddPictures(columns: columns, viewModel: viewModel, isFromEditProfile: true)
                    }
                    
                }
                
                PrimaryButton() {
                    path.append(EditProfileRoutes.editProfile3)
                }
            }.padding(.horizontal)
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: viewModel.photosPickerItems) { _, _ in
                Task {
                    await viewModel.loadSelectedImages()
                }
            }
        }
    }
}

#Preview {
    EditProfileDetailsScreen2(viewModel: ProfileViewModel(), path: .constant(NavigationPath()))
}
