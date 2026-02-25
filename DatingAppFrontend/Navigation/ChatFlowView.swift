//
//  ChatFlowView.swift
//  DatingAppFrontend
//
//  Created by Antigravity on 20/02/26.
//

import SwiftUI
import Combine

enum ChatRoute: Hashable, Equatable {
    case chat(InboxItem)
    case profile(DiscoverProfile)
}

struct ChatFlowView: View {
    @Binding var path: NavigationPath
    @ObservedObject var discoverViewModel: DiscoverViewModel
    
    var body: some View {
        NavigationStack(path: $path) {
            ChatListScreen(path: $path)
                .navigationDestination(for: ChatRoute.self) { route in
                    switch route {
                    case .chat(let item):
                        ChatView(
                            conversationId: item.conversationId,
                            receiverId: item.profileId,
                            receiverName: item.userName,
                            receiverImageURL: item.profile
                        )
                        .toolbar(.hidden, for: .tabBar)
                        
                    case .profile(let profile):
                        ProfileScreenView(path: $path, profile: profile, viewModel: discoverViewModel)
                            .toolbar(.hidden, for: .tabBar)
                    }
                }
        }
    }
}
