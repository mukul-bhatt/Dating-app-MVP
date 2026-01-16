//
//  imageSubmitTest.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 14/01/26.
//

import SwiftUI
import PhotosUI

struct imageSubmitTest: View {
    
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        // Add Profiles Section
        VStack(spacing: 20){
            // Header section
            ProfileSetupHeader()
            
            // Divider
            Rectangle()
                .fill(.white)
                .frame(height: 5)
            
            
//            Spacer()
            AddPictures(columns: columns, viewModel: viewModel)
            
            PrimaryButton(){
                                Task {
                                    do{
                                        try await viewModel.uploadImageToServer()
//                                        print("✅ Upload Successful")
                                    }catch{
                                        print("❌ Upload Failed: \(error.localizedDescription)")
                                    }
                                    
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
            
    }
}

#Preview {
    imageSubmitTest()
}
