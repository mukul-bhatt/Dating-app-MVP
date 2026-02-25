//
//  TypingViewModel.swift
//  DatingAppFrontend
//
//  Created by Antigravity on 25/02/26.
//

import Foundation
import Combine

class TypingViewModel: ObservableObject {
    private let conversationId: Int
    private let receiverId: Int
    private var isCurrentlyTyping: Bool = false
    private var typingTimer: Timer?
    
    init(conversationId: Int, receiverId: Int) {
        self.conversationId = conversationId
        self.receiverId = receiverId
    }
    
    /// Handles text change in the chat input field.
    /// Sends 'typing' event if not already sent, and resets a timer to send 'typing_stop'.
    func handleTextChange(_ text: String) {
        let isTextNotEmpty = !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        
        if isTextNotEmpty && !isCurrentlyTyping {
            sendTypingStatus(isTyping: true)
        }
        
        // Reset timer regardless of text state to ensure typing_stop goes out eventually
        typingTimer?.invalidate()
        typingTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { [weak self] _ in
            self?.sendTypingStatus(isTyping: false)
        }
    }
    
    /// Sends the typing status via the ChatSocketManager
    private func sendTypingStatus(isTyping: Bool) {
        guard isCurrentlyTyping != isTyping else { return }
        
        self.isCurrentlyTyping = isTyping
        let status = isTyping ? "typing" : "typing_stop"
        
        let payload = SocketTypingPayload(
            MessageType: status,
            ConversationId: conversationId,
            ReceiverId: receiverId,
            IsTyping: isTyping
        )
        
        print("⌨️ Sending typing event: \(status) for receiver \(receiverId)")
        ChatSocketManager.shared.sendMessage(payload: payload)
    }
    
    deinit {
        typingTimer?.invalidate()
        if isCurrentlyTyping {
            sendTypingStatus(isTyping: false)
        }
    }
}
