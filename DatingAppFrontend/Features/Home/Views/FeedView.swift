//
//  FeedView.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 28/01/26.
//

import SwiftUI

//let interests = ["Vegan", "Loves pet", "Model"]

struct FeedView: View {
   
    
    @Binding var path: NavigationPath
    let profile: DiscoverProfile
    @ObservedObject var viewModel: DiscoverViewModel
    
    @State private var showFilterModal = false
    var body: some View {
        ZStack {
            
            AppTheme.backgroundPink.ignoresSafeArea()
            
            // 1. Background Image
            BackgroundImageView(imageUrl: profile.profileImagesArray.first)
 
            // 2. Gradient Overlay
            GradientOverlay()
            
            // 3. Content Layer
            VStack {
                
//                FeedHeader(showFilterModal: $showFilterModal)
                Spacer()
                
                // Profile Details Area
                ProfileDetailsView(path: $path, profile: profile)
                
                // Interests
                InterestView(interests: profile.interestsArray)
                
                // Action Buttons
                ActionButtonsProfile(onDislike:{
                   await viewModel.dislikeProfile(id:profile.id)
                })

            }.padding()
            
        }.navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // A. The Title (Centered automatically by iOS)
                ToolbarItem(placement: .principal) {
                    Text("My Feed")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                
                // B. The Filter Button (Aligned to the Right/Trailing)
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        print("Filter tapped")
                        showFilterModal = true
                    }) {
                        Image("FilterIcon") // Your custom icon asset
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }
                    .buttonStyle(.plain)
                }
            }
            .sheet(isPresented: $showFilterModal) {
                FilterModal(viewModel: viewModel, path: $path, showFilterModal: $showFilterModal)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
                    .presentationBackground(.white)
            }
        
            // 5. Make the Bar Transparent & Back Button White
//            .toolbarBackground(.hidden, for: .navigationBar)
//            .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

struct InterestView: View {
    let interests: [String]
    var body: some View {
        // Interests
        HStack(spacing: 20){
            
            ForEach(interests.prefix(3).indices, id: \.self){ index in
                Text(interests[index])
                    .font(.headline)
                    .fontWeight(.light)
                    .foregroundStyle(Color.primary.opacity(0.7))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.white.opacity(0.7))
                    .clipShape(Capsule())
            }
        }
    }
}

struct ProfileDetailsView: View {
    
    @Binding var path: NavigationPath
    
    let profile: DiscoverProfile
    
    
    
    var body: some View {
        
        let matchString = profile.matchPercent
        // Convert String -> Double -> Int
        let matchInt = Int(Double(matchString) ?? 0)
        
        let distanceInKMString = profile.distanceInKM
        let distanceInKM = Int(Double(distanceInKMString) ?? 0)
        
        VStack(alignment: .leading, spacing: 8) {
            
            Label("View Profile", systemImage: "eye.fill")
                .font(.headline)
                .fontWeight(.light)
                .foregroundColor(.primary.opacity(0.7))
                .onTapGesture {
                    path.append(DiscoverRoute.Profile(profileId: profile.id))
                }
            
            
            HStack {
                Text("\(profile.fullName), \(profile.displayAge)")
                    .font(.title)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                
                Spacer()
                
                // Match % Badge
                HStack {
                    Image("HeartIcon")
                    Text("\(matchInt)%")
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color.white.opacity(0.8))
                .clipShape(Capsule())
            }
            
            
            
            Label {
                Text("\(distanceInKM)km away")
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary.opacity(0.5))
            } icon: {
                Image("LocationPin")
            }
            
        }
        .padding(.horizontal)
        .padding(.bottom, 20)
        
    }
}


struct GradientOverlay: View {
    var body: some View {
        LinearGradient(
            stops: [
                    // Stop 1: Light Pink (35% opacity) at the very top (0%)
                    .init(
                        color: Color(red: 255/255, green: 224/255, blue: 236/255).opacity(0.35),
                        location: 0.0
                    ),
                    
                    // Stop 2: Deep Hot Pink (99% opacity) at ~79% down the screen
                    .init(
                        color: Color(red: 223/255, green: 70/255, blue: 118/255).opacity(0.99),
                        location: 0.7933
                    )
                ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}

struct BackgroundImageView: View {
    
    let imageUrl: String?
    
    let defaultUrl = "https://images.pexels.com/photos/5384278/pexels-photo-5384278.jpeg"
    
    var body: some View {
        
        let finalUrl = (imageUrl == nil || imageUrl?.isEmpty == true) ? defaultUrl : imageUrl!
        
        AsyncImage(url: URL(string: finalUrl)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity) // Force it to fill the screen
                .clipped()
        } placeholder: {
            Color.gray
        }
        .ignoresSafeArea()
    }
}






struct FeedHeader : View {
    @Binding var showFilterModal: Bool
    var body: some View {
        HStack {
            Image("FilterIcon")
                .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
                    .opacity(0)
            
            Spacer()
            Text("My Feed")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Spacer()
            Image("FilterIcon")
                .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.red)
                    .onTapGesture{
                        showFilterModal = true
                    }
            
        }
    }
}

#Preview {
    // Uses the static mock we just created
    FeedView(
        path: .constant(NavigationPath()),
        profile: .mock,
        viewModel: DiscoverViewModel()
           
    )
}
