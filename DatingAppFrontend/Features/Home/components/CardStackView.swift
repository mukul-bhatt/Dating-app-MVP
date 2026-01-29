//
//  CardStackView.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 27/01/26.
//

import SwiftUI

enum SwipeDirection {
    case left
    case right
}


struct CardStackView: View {
    @ObservedObject var viewModel: DiscoverViewModel
    @Binding var triggerSwipe: SwipeDirection?
    @Binding var path: NavigationPath
    
    var body: some View {
        ZStack{
            // Only render the next 3 cards
            ForEach(viewModel.currentIndex..<min(viewModel.currentIndex + 3, viewModel.users.count), id: \.self) { index in
                let profile = viewModel.users[index]
            
                ProfileCard(
                    profile: profile,
                    onSwipe: { direction in
                        await viewModel.handleSwipe(direction: direction, profile: profile)
                    },
                    triggerSwipe: index == viewModel.currentIndex ? $triggerSwipe : .constant(nil)
                )
                .id(profile.id)
                .zIndex(Double(viewModel.users.count - index))
                .offset(y: CGFloat(index - viewModel.currentIndex) * 10)
                .disabled(index != viewModel.currentIndex)
                .onTapGesture {
                    // I need to navigate to Feed Screen
                    path.append(DiscoverRoute.Feed(profileId: profile.id))
                    
                }
            }
            
            // Show "No more profiles" when done
            if viewModel.currentIndex >= viewModel.users.count {
                Text("No more profiles")
                    .font(.title)
                    .foregroundColor(.gray)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            Task{
                do{
                   try await viewModel.getUserProfiles()
                    print("Profiles fetched successfully")
                }catch{
                    print("Error fetching profiles: \(error)")
                }
            }
        }
    }
    
   
}












//#Preview {
//    CardStackView()
//}
