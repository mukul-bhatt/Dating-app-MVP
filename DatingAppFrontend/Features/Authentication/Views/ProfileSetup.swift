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
    
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        VStack(spacing: 20){
            // Header section
            ProfileSetupHeader()
            
            // Divider
            Rectangle()
                .fill(.white)
                .frame(height: 5)
            
            // Add your Pictures section
            ScrollView(showsIndicators: false){
                VStack(spacing: 20){
                    // Add Profiles Section
                    AddPictures(columns: columns, selectedImages: $viewModel.selectedImage, photoPickerItems: $viewModel.photosPickerItems)
                    
                    // Your Location
                    YourLocation(viewModel: viewModel)
                    
                    // Distance Slider
                    DistanceSlider()
                    
                    AddPicturesHeader(title: "About You", subTitle: "Help us know you better")
                    
                    // Your Pronouns
                    YourPronouns(viewModel: viewModel)
                    
                    // Sexuality Section
                    SexualitySection(viewModel: viewModel)
                    
                    // Bio Section
                    BioSection(bio: $viewModel.bio)
                    
                    // Your Religion Section
                    YourReligion(viewModel: viewModel, title:"YourReligion", isMultiSelect: false)
                    
                    // Work Education Section
                    WorkEducationView(viewModel: viewModel)
                    
                    // Preferences
                    AddPicturesHeader(title: "Preferences", subTitle: "Let's customise your feed")
                    
                    // Distance Slider
                    DistanceSlider()
                    
                    // Partner's Religion
                    YourReligion(viewModel: viewModel, title:"Partner's Religion", isMultiSelect: true)
                    
                    
                    // Partner's Sexuality
                    SexualitySection(viewModel: viewModel, isMultiSelect: true)
                }
            }
            
            PrimaryButton(buttonText: "Next"){
                // Before doing anything else, see the data in the console
                print("Button was tapped")
                    viewModel.printDataSnapshot()
                
//                    if viewModel.isFormValid {
//                        // proceed to network call
//                       
//                    }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color("BrandColor"))
        .onChange(of: viewModel.photosPickerItems) { oldValue, newValue in
            Task{
                viewModel.selectedImage.removeAll()
                
                for item in newValue{
                    if let data = try? await item.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        viewModel.selectedImage.append(image)
                    }
                }
            }
        }
    }
    
}

#Preview {
    ProfileSetup()
}


