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
//    case logout
}


struct EditProfileFlowView: View {
    
    @State var path = NavigationPath()
    @StateObject var profileViewModel = ProfileViewModel()
    
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
                            ContactDetailsView(viewModel: profileViewModel)
                        case .notificationSetting:
                            NotificationSettingView()
                        case .myMatches:
                            MyMatchesView()
                        case .privacySettings:
                            PrivacySettingsView()
                        case .deleteAccount:
                            DeleteAccountView()
                        
                        }
                    }
                    .toolbar(.hidden, for: .tabBar)
                }
        }
        .onAppear {
            Task {
                await profileViewModel.loadProfileData()
            }
        }
    }
}

#Preview {
    EditProfileFlowView()
}
