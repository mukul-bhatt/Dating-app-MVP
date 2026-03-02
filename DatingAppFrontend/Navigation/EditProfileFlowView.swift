//
//  EditProfileFlowView.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 11/02/26.
//

import SwiftUI

enum EditProfileRoutes: Hashable {
    case editProfile
    case editProfile2
    case editProfile3
    case contactDetails 
    case notificationSetting
    case myMatches
    case privacySettings
    case deleteAccount
    case blockList
    case matchProfile(DiscoverProfile)
    case chat(UserMatch)
//    case logout
}


struct EditProfileFlowView: View {
    
    @State var path = NavigationPath()
    @StateObject var profileViewModel = ProfileViewModel()
    @EnvironmentObject var authViewModel: AuthViewModel
    
    init() {
        // Note: @EnvironmentObject is not available here, 
        // we'll set it in .onAppear or via .task
    }
    
    var body: some View {
        NavigationStack(path: $path){
            EditProfileMain(path: $path, viewModel: profileViewModel)
                .navigationDestination(for: EditProfileRoutes.self) { route in
                    Group {
                        switch route {
                        case .editProfile:
                            EditProfileDetailsScreen(viewModel: profileViewModel, path: $path)
                        case .editProfile2:
                            EditProfileDetailsScreen2(viewModel: profileViewModel, path: $path)
                        case .editProfile3:
                            EditProfileDetailsScreen3(viewModel: profileViewModel, path: $path)
                        case .contactDetails:
                            ContactDetailsView()
                        case .notificationSetting:
                            NotificationSettingView()
                        case .myMatches:
                            MyMatchesView(path: $path)
                        case .privacySettings:
                            PrivacySettingsView()
                        case .deleteAccount:
                            DeleteAccountView()
                        case .blockList:
                            BlockListView(path: $path)
                        case .matchProfile(let profile):
                            ProfileScreenView(path: $path, profile: profile, viewModel: DiscoverViewModel())
                        case .chat(let match):
                            ChatView(
                                conversationId: match.conversationId ?? 0,
                                receiverId: match.matchedUserId,
                                receiverName: match.fullName,
                                receiverImageURL: URL(string: match.profilePicture ?? match.latestProfileImage ?? match.profileImage ?? "")
                            )
                        }
                    }
                    .toolbar(.hidden, for: .tabBar)
                }
        }
        .onAppear {
            // Inject AuthViewModel for data syncing
            profileViewModel.authViewModel = authViewModel
            
            Task {
                await profileViewModel.loadProfileData()
            }
        }
    }
}

#Preview {
    EditProfileFlowView()
}
