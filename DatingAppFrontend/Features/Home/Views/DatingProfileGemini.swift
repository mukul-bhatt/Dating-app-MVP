// //
// //  DatingProfileView.swift
// //  DatingAppFrontend
// //
// //  Created by Mukul Bhatt on 28/01/26.
// //


// import SwiftUI

// struct DatingFeedView: View {
//     var body: some View {
//         ZStack {
//             // 1. Background Image
//             AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1616091093747-4c8d1234a7ad?q=80&w=2787&auto=format&fit=crop")) { image in
//                 image
//                     .resizable()
//                     .aspectRatio(contentMode: .fill)
//                     .ignoresSafeArea()
//             } placeholder: {
//                 Color.gray
//             }
            
//             // 2. Gradient Overlay (To make text readable)
//             LinearGradient(
//                 colors: [Color.clear, Color.clear, Color(red: 0.9, green: 0.2, blue: 0.4).opacity(0.8)],
//                 startPoint: .top,
//                 endPoint: .bottom
//             )
//             .ignoresSafeArea()
            
//             // 3. Content Layer
//             VStack {
//                 // Header
//                 HStack {
//                     Spacer()
//                     Text("My Feed")
//                         .font(.headline)
//                         .foregroundColor(.white)
//                     Spacer()
//                     Image(systemName: "slider.horizontal.3")
//                         .foregroundColor(.white)
//                 }
//                 .padding()
                
//                 Spacer() // Pushes everything down
                
//                 // Profile Details Area
//                 VStack(alignment: .leading, spacing: 8) {
//                     Label("View Profile", systemImage: "eye.fill")
//                         .font(.caption)
//                         .foregroundColor(.black.opacity(0.7))
                    
//                     HStack {
//                         Text("Nia Sharma, 26")
//                             .font(.title)
//                             .fontWeight(.bold)
//                             .foregroundColor(.black)
                        
//                         Spacer()
                        
//                         // Match % Badge
//                         HStack {
//                             Image(systemName: "heart.fill")
//                             Text("89%")
//                         }
//                         .padding(.horizontal, 12)
//                         .padding(.vertical, 8)
//                         .background(Color.white.opacity(0.8))
//                         .clipShape(Capsule())
//                     }
                    
//                     Label("2km away", systemImage: "mappin.and.ellipse")
//                         .font(.subheadline)
//                         .foregroundColor(.black)
                    
//                     // Tags would go here (HStack of Capsules)
                    
//                 }
//                 .padding(.horizontal)
//                 .padding(.bottom, 20)
                
//                 // Action Buttons (Placeholder)
//                 HStack(spacing: 30) {
//                     Circle().frame(width: 60).foregroundColor(.white) // Pass
//                     Circle().frame(width: 80).foregroundColor(.white) // Super Like
//                     Circle().frame(width: 60).foregroundColor(.white) // Chat
//                 }
//                 .padding(.bottom, 20)
                
//                 // Custom Tab Bar (Placeholder)
//                 RoundedRectangle(cornerRadius: 30)
//                     .fill(Color.white)
//                     .frame(height: 70)
//                     .padding(.horizontal)
//                     .padding(.bottom, 10)
//             }
//         }
//     }
// }


// // Preview
// struct DatingProfileView_Previews: PreviewProvider {
//     static var previews: some View {
//         DatingFeedView()
//     }
// }
