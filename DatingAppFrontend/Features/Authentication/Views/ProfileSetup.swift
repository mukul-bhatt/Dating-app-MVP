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
    
    @ObservedObject var viewModel: ProfileViewModel
    @Binding var path: NavigationPath
    
//    @State private var navigateToInterestView: Bool = false
    
    var body: some View {
//        NavigationStack{
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
                        
                        // Your Location
                        YourLocation(viewModel: viewModel)
                        
                        // Distance Slider
                        RangeSlider(minValue: $viewModel.minValue, maxValue: $viewModel.maxValue, range: 0...65)
                        
                        AddPicturesHeader(title: "About You", subTitle: "Help us know you better")
                        
                        // Your Pronouns
                        YourPronouns(viewModel: viewModel)
                        
                        // Sexuality Section
                        SexualitySection(viewModel: viewModel)
                        
                        // Bio Section
                        BioSection(viewModel: viewModel)
                        
                        // Your Religion Section
                        YourReligion(viewModel: viewModel, title:"YourReligion", isMultiSelect: false)
                        
                        // Work Education Section
                        WorkEducationView(viewModel: viewModel)
                        
                        // Preferences
                        AddPicturesHeader(title: "Preferences", subTitle: "Let's customise your feed")
                        
                        // Age Slider
                        RangeSlider(minValue: $viewModel.minValueForAge, maxValue: $viewModel.maxValueForAge, range: 18...65, title:"Preferred age Range")
                        
                        // Partner's Religion
                        YourReligion(viewModel: viewModel, title:"Partner's Religion", isMultiSelect: true)
                        
                        
                        // Partner's Sexuality
                        SexualitySection(viewModel: viewModel, isMultiSelect: true)
                    }
                }
                
                PrimaryButton(buttonText: "Next"){
                    // Before doing anything else, see the data in the console
                    viewModel.hasAttemptedSubmit = true
                    print("Next Button was tapped on profile screen")
                    
                    if viewModel.isFormValid {
//                        navigateToInterestView = true
//                        path = NavigationPath()
                        path.append(Route.interests)
                        
                    }
                    
//                    if viewModel.isSelectedReligionValid {
//                        print("✅ Success: Moving to next screen")
//                        // navigate...
//                    } else {
//                        print("❌ Failure: Validation failed")
//                    }
                    //                    let _ = viewModel.isFormValid
                    //                    if viewModel.isFormValid {
                    //                        // proceed to nextScreen
                    //                       
                    //                    }
                    
                    
                    
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
//        .navigationDestination(isPresented: $navigateToInterestView ){
//            InterestsView(viewModel: viewModel)
//        }
    }
    
//        .navigationDestination(isPresented: $navigateToImageScreen) {
//            ImageSelectionView() // The screen you want to go to next
//        }


//#Preview {
//    ProfileSetup()
//}


