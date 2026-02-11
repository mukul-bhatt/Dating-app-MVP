//
//  EditProfileFlowView.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 11/02/26.
//

import SwiftUI

enum EditProfileRoutes: Hashable {
    case editProfile
    case contactDetails 
    case notificationSetting
    case myMatches
    case privacySettings
    case deleteAccount
    case logout
}


struct EditProfileFlowView: View {
    
    @State var path = NavigationPath()
    @StateObject var profileViewModel = ProfileViewModel()
    
    var body: some View {
        NavigationStack(path: $path){
            EditProfileMain(path: $path, viewModel: profileViewModel)
                .navigationDestination(for: EditProfileRoutes.self){
                    switch $0 {
                    case .editProfile:
                        EditProfileDetailsScreen(viewModel: profileViewModel)
                    case .contactDetails:
                        ContactDetailsView()
                    case .notificationSetting:
                        NotificationSettingView()
                    case .myMatches:
                        MyMatchesView()
                    case .privacySettings:
                        PrivacySettingsView()
                    case .deleteAccount:
                        DeleteAccountView()
                    case .logout:
                        LogoutView()
                    }
                }
        }
    }
}

#Preview {
    EditProfileFlowView()
}
