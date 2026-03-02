//
//  DiscoverFlowView.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 29/01/26.
//

import SwiftUI

enum DiscoverRoute: Hashable {
    case Feed(profileId: Int)
    case Profile(profileId: Int)
    case ReportProfile(profileId: Int)
    case Submit
    /// Used when navigating from a match notification — carries conversationId so the
    /// message button can be shown instead of the like button.
    case MatchedProfile(profile: DiscoverProfile, conversationId: Int)
}

struct DiscoverFlowView: View {

    @State var path = NavigationPath()
    @ObservedObject var viewModel: DiscoverViewModel

    var body: some View {

        NavigationStack(path: $path) {
            
            DiscoverView(path: $path, viewModel: viewModel)
                .navigationDestination(for: DiscoverRoute.self) { route in
                    
                    switch route {
                    case .Feed(let id):
                        if let profile = viewModel.users.first(where: { $0.id == id }) {
                            FeedView(path: $path, profile: profile, viewModel: viewModel)
                        }
                   
                    case .Profile(let id):
                        if let profile = viewModel.users.first(where: { $0.id == id }) {
                            ProfileScreenView(path: $path, profile: profile, viewModel: viewModel)
                                .toolbar(.hidden, for: .tabBar)
                        }

                    case .ReportProfile(let id):
                        ReportProfileView(path: $path, profileId: id, viewModel: viewModel)
                            .toolbar(.hidden, for: .tabBar)

                    case .Submit:
                        SettingUpScreen(title: "Report Submitted", subTitle: "Thanks for reporting. Our Team will review this profile shortly")
                            .toolbar(.hidden, for: .tabBar)

                    case .MatchedProfile(let profile, _):
                        // onMessage is wired up in NotificationsScreen where the path lives
                        ProfileScreenView(path: $path, profile: profile, viewModel: viewModel)
                            .toolbar(.hidden, for: .tabBar)
                     }
                }
        }
    }
}

