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
//                     Add Profiles Section
                       AddPictures(columns: columns, selectedImages: $viewModel.selectedImage, photoPickerItems: $viewModel.photosPickerItems)
                    
//                     Your Location
                       YourLocation(viewModel: viewModel)
                       YourLocation(viewModel: viewModel)
                    
//                     Distance Slider
                    DistanceSlider()
                    
                    AddPicturesHeader(title: "About You", subTitle: "Help us know you better")
                    
                    // Your Pronouns
                    YourPronouns(viewModel: viewModel)
                    
                    // Sexuality Section
                    SexualitySection(selectedSexuality: $viewModel.sexuality)
                    
                    // Bio Section
                    BioSection(bio: $viewModel.bio)
                    
                    // Your Religion Section
                    YourReligion(title:"YourReligion", selectedReligion: $viewModel.selectedReligion)
                    
                    // Work Education Section
                    WorkEducationView(viewModel: viewModel)
                    
                    // Preferences
                    AddPicturesHeader(title: "Preferences", subTitle: "Let's customise your feed")
                    
                    // Distance Slider
                    DistanceSlider()
                    
                    // Partner's Religion
                    YourReligion(title:"Partner's Religion",selectedReligion: $viewModel.selectedPartnerReligion)
                    
                    // Partner's Sexuality
                    SexualitySection(selectedSexuality: $viewModel.partnerSexuality)
                }
            }
            
            PrimaryButton().onTapGesture {
                if viewModel.isFormValid{
                    
                }
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




//    @State private var selectedImage: [UIImage] = []
//    @State private var photosPickerItems: [PhotosPickerItem] = []
//
//    // Location state
//    @State private var location: String = "New Delhi"
//
//    // Pronouns State
//    @State private var pronouns: String = ""
//
//    // Sexuality
//    @State private var sexuality: String? = nil
//
//    // bio state
//    @State private var bio: String = ""
//
//    // Religion State
//    @State private var selectedReligion: String? = nil
//
//    // Partner Religion State
//    @State private var selectedPartnerReligion: String? = nil
