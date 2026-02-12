//
//  ImageSelectionView.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 14/01/26.
//

import SwiftUI
import PhotosUI

struct ImageSelectionView: View {
    
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    @ObservedObject var viewModel: ProfileViewModel
    @Binding var path: NavigationPath
//    @StateObject private var viewModel = ProfileViewModel()
    @State private var navigateToProfileSetup: Bool = false
    @State var showErrorMessage: Bool = false
    let errorMessageForFailedUpload: String = "Images could not be uploaded Please try again"
    @State var showUploadError: Bool = false
    
    var body: some View {
        
//        NavigationStack{
            // Add Profiles Section
            VStack(spacing: 20){
                // Header section
                ProfileSetupHeader()
                
                // Divider
                Rectangle()
                    .fill(.white)
                    .frame(height: 5)
                
                
                AddPictures(columns: columns, viewModel: viewModel)
                
                if showErrorMessage {
                    withAnimation {
                        HStack(spacing: 4) {
                            Image(systemName: "exclamationmark.circle.fill")
                            Text(viewModel.errorMessageForImageSelection ?? "")
                        }
                        .font(.caption)
                        .foregroundColor(.red)
                    }
                }
                
                if showUploadError {
                    withAnimation {
                        HStack(spacing: 4) {
                            Image(systemName: "exclamationmark.circle.fill")
                            Text(errorMessageForFailedUpload)
                        }
                        .font(.caption)
                        .foregroundColor(.red)
                    }
                }
                
                PrimaryButton(){
                    
                    if viewModel.isImageSelectionValid{
                        
                        // Hide any error message
                        showErrorMessage = false
                        
                        Task {
                            do{
                                try await viewModel.uploadImages()
                                print("✅ Upload Successful")
                                
                
                                // 3. Trigger navigation on SUCCESS
                                await MainActor.run {
//                                    navigateToProfileSetup = true
//                                      path = NavigationPath()
                                      path.append(Route.profileSetup)
                                }
                                
                            }catch{
                                print("❌ Upload Failed: \(error.localizedDescription)")
                                showUploadError = true
                            }
                            
                        }
                        
                        
                    }else{
                        showErrorMessage = true
                    }
                }
            }
            .padding(.top)
            .padding()
            .background(Color("BrandColor"))
            .onChange(of: viewModel.photosPickerItems) { oldValue, newValue in
                Task{
                    viewModel.selectedImages.removeAll()
                    
                    for item in newValue{
                        if let data = try? await item.loadTransferable(type: Data.self),
                           let image = UIImage(data: data) {
                            viewModel.selectedImages.append(image)
                        }
                    }
                }
            }
            
            
//        }
//        .navigationDestination(isPresented: $navigateToProfileSetup) {
//            ProfileSetup(viewModel: viewModel)
//        }
    }
}

//#Preview {
//    ImageSelectionView()
//}
