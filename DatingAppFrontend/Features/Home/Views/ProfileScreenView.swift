//
//  ProfileScreenView.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 28/01/26.
//

import SwiftUI
import WrappingHStack

let colors = [
     Color(red: 1.0, green: 0.95, blue: 0.8),
     Color(red: 0.9, green: 1.0, blue: 0.9),
     Color(red: 0.9, green: 0.95, blue: 1.0),
     Color(red: 1.0, green: 0.85, blue: 0.85),
     Color(red: 0.85, green: 1.0, blue: 0.9),
     Color(red: 0.95, green: 0.85, blue: 1.0),
     Color(red: 0.95, green: 0.9, blue: 1.0)
]

struct ProfileScreenView: View {
    
    @Binding var path: NavigationPath
    let profile: DiscoverProfile
    @ObservedObject var viewModel: DiscoverViewModel
    
    var body: some View {
        ZStack{
            
            // Background Color
            AppTheme.backgroundPink
                    .ignoresSafeArea()
            
            ScrollView(showsIndicators: false){
                VStack(alignment: .leading, spacing: 16){
                    
                   // Top slider and Images
                    HeaderView(imageUrls: profile.profileImagesArray)
                    
                   //Primary information
                    PrimaryInformation(profile: profile)
                    
                    // Location and work information
                    LocationAndWork(location: profile.displayLocation, work: profile.job, distance: profile.distanceInKM)
                    
                    // Bio
                    Bio(bio: profile.bio)
                    
                    // Passions
                    Passions(passions: profile.interestsArray)
                    
                    // Action Buttons
                    ActionButtonsProfile(onDislike: {
                       await viewModel.dislikeProfile(id: profile.id)
                    }, onMessage: {
                        print("Closure for message")
                    })
                    
                    // Footer
                    Footer(profile:profile ,path: $path)
                        
//                    Spacer()
                }
            }.padding(.horizontal)
            
           
        }
        
       
    }
}

struct Bio: View {
    let bio: String
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Bio")
                .font(.subheadline)
                .foregroundColor(.primary)
            
            Text(bio)
                .font(.body)
                .foregroundColor(.primary)
                .lineSpacing(4)
        }
    }
}

struct LocationAndWork: View {
    let location: String
    let work: String
    let distance: String
    
    var body: some View {
        VStack(alignment:.leading ,spacing: 12) {
            
            VStack(alignment:.leading) {
                HStack{
                        Image("LocationPin")
                        Text("Location")
                            .font(.caption)
                            .foregroundColor(.primary)
                    }
                    Text("\(location)  •  \(Int(Double(distance) ?? 0)) Km away")
                        .foregroundColor(.primary)
                
            }
            
            VStack(alignment:.leading) {
                HStack{
                    Image(systemName: "briefcase")
                    Text("Work")
                        .font(.caption)
                        .foregroundColor(.primary)
                    }
                Text(work)
                    .foregroundColor(.primary)
                
            }
        }
    }
}

struct PrimaryInformation: View {
    let profile: DiscoverProfile
    var body: some View {
        
        let matchPercent = profile.matchPercent
        let matchPercentInt = Int(Double(matchPercent) ?? 0)
        
        var bioSummary: String {
            // Collect all valid pieces of info
            let parts = [
                profile.religionText,
                "\(profile.height) cm",
                profile.interestsArray.prefix(2).joined(separator: " • ")
            ].filter { !$0.isEmpty && !$0.contains("0 cm") } // Remove empty or invalid data

            return parts.joined(separator: "  •  ")
        }
        
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("\(profile.fullName), \(profile.displayAge)")
                    .font(.title)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Image(systemName: "checkmark.seal.fill")
                    .font(.title3)
                    .foregroundColor(.primary)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image("HeartIcon").font(.title)
                    Text("\(matchPercentInt)%").font(.headline)
                }
                .foregroundColor(.primary)
            }
            
            Text(bioSummary)
                .font(.subheadline)
                .foregroundColor(.primary)
        }
    }
}



struct HeaderView: View {
    

    let imageUrls: [String]
    @State var position: Int = 0
    
    // Define a fallback image URL for empty states
    private let placeholderUrl = "https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg"
    
    var body: some View{
        VStack(spacing: 0){
            if imageUrls.isEmpty {
                // 1. Placeholder State
                AsyncImage(url: URL(string: placeholderUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 400) // 1. Fix the internal image height
                        .clipped()          // 2. Cut off any horizontal overflow
                } placeholder: {
                    Color.gray
                        .frame(height: 400) // 3. Ensure placeholder matches the height
                }
                .frame(maxWidth: 370) // 4. Constrain width to parent
                .frame(height: 400)    // 5. Hard limit the container height
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .padding(.top, 10)
                
            } else {
                
                HStack(spacing: 8) {
                    
                    ForEach(imageUrls.prefix(3).indices, id: \.self) { index in
                        Capsule().fill(position == index ? AppTheme.foregroundPink : .white).frame(height: 4)
                    }
                }
                .padding(.top, 10)
                
                TabView(selection: $position){
                    
                    ForEach(imageUrls.prefix(3).indices, id: \.self) { index in
                        ImageView(position: index, imageUrls: imageUrls).tag(index)
                    }
                    
                }.tabViewStyle(.page(indexDisplayMode: .never))
                    .frame(height: 400)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            }
        }
        
    }
}



struct Footer: View {
    
    let profile: DiscoverProfile
    @Binding var path: NavigationPath
    
    var body: some View {
        // 8. Footer
        Button(action: {
            path.append(DiscoverRoute.ReportProfile(profileId: profile.id))
        }) {
            Text("Report profile")
                .font(.subheadline)
                .foregroundColor(AppTheme.foregroundPink)
                .padding(.vertical, 12)
                .padding(.horizontal, 40)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(AppTheme.foregroundPink.opacity(0.5), lineWidth: 1)
                )
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 10)
    }
}





struct Passions: View{
    let passions: [String]
    var body: some View{
        VStack(alignment: .leading, spacing: 10) {
            Text("Passion")
                .font(.subheadline)
                .foregroundColor(.primary)
            
            // Simple Flow Layout using wrapping stacks
            WrappingHStack(passions.prefix(10), id: \.self, spacing: .constant(15), lineSpacing: 10){ passion in
        
                Text(passion)
                    .font(.callout)
                    .fontWeight(.medium)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(colors.randomElement())
                    .cornerRadius(20)
                    .foregroundColor(.primary.opacity(0.8))
                }
            }
        }
    }



struct ImageView: View {
    
    var position: Int
    let imageUrls: [String]
    
    var body: some View {
        AsyncImage(url: URL(string: imageUrls[position])) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            Color.gray.opacity(0.3)
        }
        .frame(height: 400)
    }
}



#Preview {
    ProfileScreenView(
        path: .constant(NavigationPath()),
        profile: .mock,
        viewModel: DiscoverViewModel()
    )
}
