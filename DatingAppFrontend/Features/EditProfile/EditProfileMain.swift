//
//  EditProfileMain.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 11/02/26.
//

import SwiftUI

struct EditProfileMain: View {
    
    @Binding var path: NavigationPath
    @ObservedObject var viewModel: ProfileViewModel
    
    
    var body: some View {
        
        
        ZStack {
            
            AppTheme.backgroundPink.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // MARK: - Header
                header

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        
                        // MARK: - Profile Image & Info
                        VStack(spacing: 12) {
                            if let firstImageURL = viewModel.profileImageURLs.first,
                               let url = URL(string: firstImageURL) {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                            .frame(width: 180, height: 180)
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 180, height: 180)
                                            .cornerRadius(20)
                                    case .failure:
                                        Image(systemName: "person.circle.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 180, height: 180)
                                            .foregroundColor(.gray)
                                            .cornerRadius(20)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 180, height: 180)
                                    .foregroundColor(.gray)
                                    .cornerRadius(20)
                            }
                            
                            Text("\(viewModel.name), \(calculateAge(from: viewModel.dateOfBirth))")
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            Button(action: {
                                path.append(EditProfileRoutes.editProfile)
                            }) {
                                Label("Edit Profile", systemImage: "pencil")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 10)
                                    .background(AppTheme.foregroundPink)
                                    .cornerRadius(10)
                            }
                        }
                        .padding(.top)
                        
                        // MARK: - Subscription Card
//                       subscriptionCard
                        
                        // MARK: - Settings List
                        VStack(spacing: 12) {
                            ProfileMenuRow(icon: "phone.fill", title: "Contact Details")
                            ProfileMenuRow(icon: "bell.fill", title: "Notification Settings")
                            ProfileMenuRow(icon: "heart.fill", title: "My Matches")
                            ProfileMenuRow(icon: "gearshape.fill", title: "Privacy Settings")
                            ProfileMenuRow(icon: "trash.fill", title: "Delete Account")
                            ProfileMenuRow(icon: "rectangle.portrait.and.arrow.right", title: "Log Out")
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 100) // Space for Tab Bar
                    }
                    .padding(.horizontal)
                }
//                .background(Color(red: 1.0, green: 0.9, blue: 0.94))
            }
            .overlay(alignment: .bottom) {
                // Reuse the custom Tab Bar logic from previous screens here
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
    
    
    var subscriptionCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                Image(systemName: "diamond.fill")
                    .font(.title2)
                    .foregroundColor(.white)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Monthly Subscription")
                        .font(.headline)
                    Text("Unlimited texts and calls for a month")
                        .font(.subheadline)
                }
                .foregroundColor(.white)
            }
            
            Button(action: {}) {
                Text("Cancel Subscription")
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.white, lineWidth: 1)
                    )
                    .foregroundColor(.white)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(red: 0.85, green: 0.25, blue: 0.45))
        .cornerRadius(15)
        .padding(.horizontal)
    }
    
    // Helper function to calculate age from date of birth
    private func calculateAge(from dateOfBirth: Date) -> String {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: dateOfBirth, to: Date())
        return "\(ageComponents.year ?? 0)"
    }
    
    var header: some View {
        HStack {
            Button(action: {}) {
                Image(systemName: "arrow.left")
                    .padding(10)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }
            
            Spacer()
            
            Text("My Profile")
                .font(.title3)
                .fontWeight(.bold)
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "ellipsis")
                    .rotationEffect(.degrees(90))
                    .padding(10)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }
        }
        .padding()
        .foregroundColor(.black)
    }
}

struct ProfileMenuRow: View {
    let icon: String
    let title: String
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .frame(width: 20)
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .bold))
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .foregroundColor(.black)
        }
        .buttonStyle(PlainButtonStyle())
}
}


//#Preview {
//    EditProfileMain()
//}

