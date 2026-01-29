//
//  FeedView.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 28/01/26.
//

import SwiftUI

let interests = ["Vegan", "Loves pet", "Model"]

struct FeedView: View {
    var body: some View {
        ZStack {
            
            AppTheme.backgroundPink.ignoresSafeArea()
            // 1. Background Image
            AsyncImage(url: URL(string: "https://images.pexels.com/photos/5384278/pexels-photo-5384278.jpeg")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity) // Force it to fill the screen
                    .clipped()
            } placeholder: {
                Color.gray
            }
//            .ignoresSafeArea()

            
            // 2. Gradient Overlay
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
            
            // 3. Content Layer
            VStack {
                // Header
                FeedHeader()
                Spacer()
                // Profile Details Area
                VStack(alignment: .leading, spacing: 8) {
                    
                    Label("View Profile", systemImage: "eye.fill")
                        .font(.headline)
                        .fontWeight(.light)
                        .foregroundColor(.primary.opacity(0.7))
                    
                    
                    HStack {
                        Text("Nia Sharma, 26")
                            .font(.title)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                        
                        
                        Spacer()
                        
                        // Match % Badge
                        HStack {
                            Image("HeartIcon")
                            Text("89%")
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.white.opacity(0.8))
                        .clipShape(Capsule())
                    }
                    
                    
                    
                    Label {
                        Text("2km away")
                            .font(.headline)
                            .fontWeight(.medium)
                            .foregroundColor(.primary.opacity(0.5))
                    } icon: {
                        Image("LocationPin")
                    }
                    
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
                
                
                
                // Interests
                HStack(spacing: 20){
                    Text(interests[0])
                        .font(.headline)
                        .fontWeight(.light)
                        .foregroundStyle(Color.primary.opacity(0.7))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.white.opacity(0.7))
                        .clipShape(Capsule())
                    
                    Text(interests[1])
                        .font(.headline)
                        .fontWeight(.light)
                        .foregroundStyle(Color.primary.opacity(0.7))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.white.opacity(0.7))
                        .clipShape(Capsule())
                    
                    Text(interests[2])
                        .font(.headline)
                        .fontWeight(.light)
                        .foregroundStyle(Color.primary.opacity(0.7))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.white.opacity(0.7))
                        .clipShape(Capsule())
                }
                
                
                
                
                ActionButtonsProfile()
//                Spacer()

            }.padding()
            
        }
    }
}


struct FeedHeader : View {
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
            
        }
    }
}

#Preview{
    FeedView()
}
