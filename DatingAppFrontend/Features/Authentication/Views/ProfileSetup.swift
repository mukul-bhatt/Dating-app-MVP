//
//  ProfileSetup.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 08/01/26.
//

import SwiftUI
import PhotosUI


struct ProfileSetup: View {
    
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    @State private var selectedImage: [UIImage] = []
    @State private var photosPickerItems: [PhotosPickerItem] = []
    
    var body: some View {
        VStack(spacing: 20){
            // Header section
            ProfileSetupHeader()
            
            // Divider
            Rectangle()
                .fill(.white)
                .frame(height: 5)
            
            // Add your Pictures section
            AddPictures(columns: columns, selectedImages: $selectedImage, photoPickerItems: $photosPickerItems)
            
            
            Spacer()
            
            PrimaryButton()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color("BrandColor"))
        .onChange(of: photosPickerItems) { oldValue, newValue in
            Task{
                selectedImage.removeAll()
                
                for item in newValue{
                    if let data = try? await item.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        selectedImage.append(image)
                    }
                }
            }
        }
    }
    
    struct AddPictures: View {
        let columns: [GridItem]
        @Binding var selectedImages: [UIImage]
        @Binding var photoPickerItems: [PhotosPickerItem]  // Add this binding
        
        var body: some View {
            AddPicturesHeader()
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
    
    
    struct ProfileSetupHeader: View {
        var body: some View {
            VStack(spacing: 12) {
                Text("Setup your Profile")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.primary)
                
                Text("Tell us a little about yourself — the better we know you, the better your feed gets.")
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 24)
            .padding(.top, 40)
        }
    }
    
    struct AddPicturesHeader: View {
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text("Add your pictures")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                
                Text("Add a photo so people can see the real you!")
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    
    
    struct AddPictureButton: View {
        var body: some View {
            VStack(spacing: 12) {
                Image(systemName: "plus")
                    .font(.system(size: 40, weight: .thin))
                    .foregroundColor(.black)
                
                Text("Add Pictures")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)
            }
            .frame(height: 200)
            .frame(maxWidth: .infinity)
            .background(Color.white.opacity(0.5))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.black, lineWidth: 1.5)
            )
        }
    }
    
    struct ImageCell: View {
        let image: UIImage
        
        var body: some View {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
//                .frame(maxWidth: .infinity)
                .frame(width: 150, height: 200, )
                .clipped()
                .cornerRadius(12)
        }
    }
    
   
}

#Preview {
    ProfileSetup()
}
