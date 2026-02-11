//
//  ChatListViewModel.swift
//  DatingAppFrontend
//
//  Created by Antigravity on 06/02/26.
//

import Foundation
import Combine

class ChatListViewModel: ObservableObject {
    @Published var onlineUsers: [MatchStatusUser] = []
    @Published var inboxItems: [InboxItem] = []
    var notificationsManager: NotificationsManager?
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupSocketCallbacks()
        fetchInbox()
    }
    
    func setupSocketCallbacks() {
        ChatSocketManager.shared.matchStatusSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self = self else { return }
                
                if event.type == "match_status_list" {
                    print("🔥 Full Match Status List received: \(event.users.count) users")
                    self.onlineUsers = event.users
                } else {
                    // Incremental update (single user)
                    print("🔥 Incremental Match Status Update: \(event.users.count) users")
                    
                    var currentList = self.onlineUsers
                    for userUpdate in event.users {
                        if let index = currentList.firstIndex(where: { $0.userId == userUpdate.userId }) {
                            // Update existing user properties while keeping name/image from local
                            let old = currentList[index]
                            currentList[index] = MatchStatusUser(
                                userId: old.userId,
                                name: old.name, // Keep existing name
                                isOnline: userUpdate.isOnline,
                                lastSeen: userUpdate.lastSeen,
                                profileImage: old.profileImage // Keep existing image
                            )
                        } else if userUpdate.isOnline {
                            // Only add if they are online and new
                            currentList.append(userUpdate)
                        }
                    }
                    self.onlineUsers = currentList
                }
            }
            .store(in: &cancellables)
    }
    
    func fetchInbox() {
        Task {
            do {
                let response: InboxResponse = try await NetworkManager.shared.request(endpoint: .getInbox)
                if response.success {
                    await MainActor.run {
                        self.inboxItems = response.data
                        self.notificationsManager?.inboxItems = response.data
                        print("📫 Inbox fetched: \(self.inboxItems.count) conversations")
                    }
                }
            } catch {
                print("❌ Failed to fetch inbox: \(error)")
            }
        }
    }
}
