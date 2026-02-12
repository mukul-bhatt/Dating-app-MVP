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
                        // Find the profile in the array using the ID
                        if let profile = viewModel.users.first(where: { $0.id == id }) {
                            FeedView(path: $path, profile: profile, viewModel:viewModel)
                                // Tab bar remains visible for Feed
                        }
                   
                        case .Profile(let id):
                            if let profile = viewModel.users.first(where: { $0.id == id }) {
                                ProfileScreenView(path: $path, profile: profile, viewModel: viewModel)
                                    .toolbar(.hidden, for: .tabBar)
                            }

                        case .ReportProfile(let id):
                            if let profile = viewModel.users.first(where: { $0.id == id }) {
                                ReportProfileView(path: $path, profile: profile, viewModel: viewModel)
                                    .toolbar(.hidden, for: .tabBar)
                            }

                        case .Submit:
                            SettingUpScreen(title: "Report Submitted", subTitle: "Thanks for reporting. Our Team will review this profile shortly")
                                .toolbar(.hidden, for: .tabBar)
                    }
                
                
            }
                      
        }
        
    }
}

