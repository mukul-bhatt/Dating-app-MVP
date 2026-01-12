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
        @Binding var selectedImages: [UIImage]
        @Binding var photoPickerItems: [PhotosPickerItem]
        
        var body: some View {
            AddPicturesHeader(title: "Add your pictures", subTitle: "Add a photo so people can see the real you!")
            ScrollView{
                
                LazyVGrid(columns: columns, spacing: 16) {
                    // Wrap button in PhotosPicker
                    PhotosPicker(selection: $photoPickerItems, maxSelectionCount: 6, matching: .images) {
                        AddPictureButton()
                    }
                    
                    ForEach(selectedImages.indices, id: \.self) { index in
                        ImageCell(image: selectedImages[index])
                    }
                }
                .padding(.horizontal, 24)
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
        .frame(height: 200)
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.5))
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
        //                .frame(maxWidth: .infinity)
            .frame(width: 150, height: 200)
            .clipped()
            .cornerRadius(12)
    }
}

