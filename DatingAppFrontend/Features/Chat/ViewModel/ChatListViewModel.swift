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
    
    init() {
        setupSocketCallbacks()
        fetchInbox()
    }
    
    func setupSocketCallbacks() {
        ChatSocketManager.shared.onMatchStatusReceived = { [weak self] event in
            print("🔥 ViewModel received match status update: \(event.users.count) users")
            DispatchQueue.main.async {
                self?.onlineUsers = event.users
            }
        }
    }
    
    func fetchInbox() {
        Task {
            do {
                let response: InboxResponse = try await NetworkManager.shared.request(endpoint: .getInbox)
                if response.success {
                    await MainActor.run {
                        self.inboxItems = response.data
                        print("📫 Inbox fetched: \(self.inboxItems.count) conversations")
                    }
                }
            } catch {
                print("❌ Failed to fetch inbox: \(error)")
            }
        }
    }
}
