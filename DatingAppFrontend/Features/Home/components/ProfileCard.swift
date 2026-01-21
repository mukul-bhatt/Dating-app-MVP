////
////  ProfileCard.swift
////  DatingAppFrontend
////
////  Created by Mukul Bhatt on 21/01/26.
////
//
//import SwiftUI
//
//struct ProfileCard: View {
////    let profile: Profile
//    
//    var body: some View {
//        ZStack(alignment: .bottomLeading) {
//            // Background with placeholder
//            RoundedRectangle(cornerRadius: 25)
//                .fill(
//                    LinearGradient(
//                        colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.5)],
//                        startPoint: .topLeading,
//                        endPoint: .bottomTrailing
//                    )
//                )
//            
//            // Gradient overlay at bottom
//            LinearGradient(
//                colors: [Color.clear, Color.black.opacity(0.3)],
//                startPoint: .center,
//                endPoint: .bottom
//            )
//            .cornerRadius(25)
//            
//            // Profile info
//            HStack(alignment: .bottom) {
//                VStack(alignment: .leading, spacing: 8) {
//                    Text("\(profile.name) ,\(profile.age)")
//                        .font(.system(size: 28, weight: .bold))
//                        .foregroundColor(.white)
//                    
//                    HStack(spacing: 5) {
//                        Image(systemName: "mappin.and.ellipse")
//                            .font(.system(size: 14))
//                        Text(profile.distance)
//                            .font(.system(size: 16))
//                    }
//                    .foregroundColor(.white)
//                }
////                
////                Spacer()
////                
////                // Match percentage
////                HStack(spacing: 8) {
////                    Image(systemName: "moon.stars.fill")
////                        .font(.system(size: 16))
////                    Text("\(profile.matchPercentage)%")
////                        .font(.system(size: 18, weight: .semibold))
////                }
////                .foregroundColor(Color(red: 0.3, green: 0.2, blue: 0.4))
////                .padding(.horizontal, 20)
////                .padding(.vertical, 12)
////                .background(Color.white.opacity(0.95))
////                .cornerRadius(25)
////            }
////            .padding(25)
//        }
//        .frame(maxWidth: .infinity)
//        .frame(height: 480)
//        .shadow(color: .black.opacity(0.2), radius: 20)
//    }
//}
//
//
////#Preview{
////    ProfileCard()
////}
