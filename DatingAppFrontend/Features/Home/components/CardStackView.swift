//
//  CardStackView.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 27/01/26.
//

import SwiftUI

struct CardStackView: View {
    @ObservedObject var viewModel: DiscoverViewModel
    @Binding var triggerSwipe: SwipeDirection?
    @Binding var path: NavigationPath
    
    
    var body: some View {
        ZStack{
            // Only render the next 3 cards
            if !viewModel.users.isEmpty {
                ForEach(viewModel.currentIndex..<min(viewModel.currentIndex + 3, viewModel.users.count), id: \.self) { index in
                    let profile = viewModel.users[index]
                    let cardOffset = index - viewModel.currentIndex
                    
                    // Calculate X offset for fan-out effect
                    let xOffset: CGFloat = {
                        switch cardOffset {
                        case 0: return 0 // Top card - centered
                        case 1: return 30 // Second card - peek right
                        case 2: return -30 // Third card - peek left
                        default: return 0
                        }
                    }()
                    
                    // Calculate rotation angle for tilt effect
                    let rotationAngle: Double = {
                        switch cardOffset {
                        case 0: return 0 // Top card - no tilt
                        case 1: return 5 // Second card - tilt right
                        case 2: return -5 // Third card - tilt left
                        default: return 0
                        }
                    }()
                
                    ProfileCard(
                        profile: profile,
                        onSwipe: { direction in
                            await viewModel.handleSwipe(direction: direction, profile: profile)
                        },
                        triggerSwipe: index == viewModel.currentIndex ? $triggerSwipe : .constant(nil)
                    )
                    .id(profile.id)
                    .zIndex(Double(viewModel.users.count - index))
                    // Fan-out stacking effect with rotation
                    .scaleEffect(1 - (CGFloat(cardOffset) * 0.06)) // Each card 5% smaller
                    .rotationEffect(.degrees(rotationAngle)) // Tilt cards left/right
                    .offset(x: xOffset) // Fan out horizontally
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
            
        }
        .navigationBarHidden(true)
        .onAppear {
            Task {
                
                if !viewModel.hasFetchedInitialData {
                    do {
                        try await viewModel.getUserProfiles()
                        
                    } catch {
                        print("Error fetching profiles: \(error)")
                    }
                }
            }
        }
    }
    
   
}












//#Preview {
//    CardStackView()
//}

