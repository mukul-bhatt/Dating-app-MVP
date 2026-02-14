//
//  EditProfileViewModel.swift
//  DatingAppFrontend
//
//  Created by Antigravity on 13/02/26.
//

import SwiftUI
import Combine
import PhotosUI

@MainActor
class EditProfileViewModel: ObservableObject {
    // MARK: - Profile Picture Upload
    @Published var isUploadingProfilePicture: Bool = false
    @Published var selectedProfilePicture: UIImage? = nil
    @Published var profilePicturePickerItems: [PhotosPickerItem] = []
    @Published var uploadError: String? = nil
    
    // MARK: - Load Selected Image
    func loadSelectedProfilePicture(profileViewModel: ProfileViewModel) async {
        guard let item = profilePicturePickerItems.first else { return }
        
        do {
            if let data = try await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                self.selectedProfilePicture = image
                // Automatically trigger upload after image is loaded
                await uploadProfilePicture(profileViewModel: profileViewModel)
            }
        } catch {
            print("❌ Failed to load image: \(error)")
            self.uploadError = "Failed to load selected image"
        }
    }
    
    // MARK: - Upload Profile Picture
    func uploadProfilePicture(profileViewModel: ProfileViewModel) async {
        guard let image = selectedProfilePicture else {
            print("⚠️ No image selected to upload")
            return
        }
        
        isUploadingProfilePicture = true
        uploadError = nil
        
        do {
            // Upload to /profile/update-profile endpoint
            let response: ProfilePictureUploadResponse = try await NetworkManager.shared.upload(
                endpoint: .updateProfilePicture,
                images: [image],
                imageFieldName: "File",
                useIndexedFieldNames: false
            )
            
            if response.success {
                print("✅ Profile picture uploaded successfully: \(response.data.imageUrl)")
                
                // Update ProfileViewModel with new image URL from response
                await MainActor.run {
                    profileViewModel.profilePicture = response.data.imageUrl
                    
                    // Clear selected image after updating URL
                    self.selectedProfilePicture = nil
                    self.profilePicturePickerItems = []
                    print("✅ Profile picture updated to: \(response.data.imageUrl)")
                }
            } else {
                self.uploadError = response.message
                print("❌ Upload failed: \(response.message)")
            }
            
        } catch {
            self.uploadError = "Failed to upload profile picture. Please try again."
            print("❌ Upload error: \(error)")
        }
        
        isUploadingProfilePicture = false
    }
}

// MARK: - API Response Models

struct ProfilePictureUploadResponse: Codable {
    let success: Bool
    let message: String
    let data: ProfilePictureData
}

struct ProfilePictureData: Codable {
    let profileId: Int
    let imageUrl: String
}
