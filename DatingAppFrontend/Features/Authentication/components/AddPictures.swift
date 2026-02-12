//
//  AddPictures.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 11/01/26.
//

import SwiftUI
import PhotosUI

// Add your Pictures Section
    struct AddPictures: View {
        let columns: [GridItem]
        
        @ObservedObject var viewModel: ProfileViewModel
        var isFromEditProfile: Bool = false
        
        var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                AddPicturesHeader(title: "Add your pictures", subTitle: "Add a photo so people can see the real you!", isFromEditProfile: isFromEditProfile)
                
                LazyVGrid(columns: columns, spacing: 16) {
                    // Wrap button in PhotosPicker
                    PhotosPicker(selection: $viewModel.photosPickerItems, maxSelectionCount: 6, matching: .images) {
                        AddPictureButton()
                    }
                    
                    ForEach(viewModel.selectedImages.indices, id: \.self) { index in
                        ImageCell(image: viewModel.selectedImages[index])
                    }
                }
            }
        }
    }


// Add Pictures Button
struct AddPictureButton: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "plus")
                .font(.system(size: 40, weight: .thin))
                .foregroundColor(.primary)
            
            Text("Add Pictures")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.primary)
        }
        .frame(height: 180)
        .frame(maxWidth: .infinity)
//        .background(Color.white.opacity(0.5))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.primary, lineWidth: 1.5)
        )
    }
}

// Image cell
struct ImageCell: View {
    let image: UIImage
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .frame(width:180,height: 180)
            .frame(maxWidth: .infinity)
            .clipped()
            .cornerRadius(12)
    }
}

