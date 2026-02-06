//
//  ChatViewModel.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 04/02/26.
//

import Foundation
import Combine




class ChatViewModel: ObservableObject
{
    
    @Published var lastMessageId: UUID?
    
    @Published var messages: [Message] = [
        Message(text: "Okay, important question: are you a morning person or a 'don't talk to me until I've had coffee' person ?", isFromMe: false),
        Message(text: "Haha definitely the second one. I'm basically a friendly zombie until caffeine kicks in.", isFromMe: true),
        Message(text: "Love that honesty 😂 I'm the annoying one who wakes up at 7am and starts texting people memes.", isFromMe: false),
        Message(text: "Let me guess... you send a \"good morning, sunshine\" gif at 7:02am?", isFromMe: true),
        Message(text: "Guilty. But only to the special ones. Like my dog... and now maybe you?", isFromMe: false),
        Message(text: "Aw wow, already in the inner circle? I must be doing something right.", isFromMe: true)
    ]
    
    @Published var messageFieldValue: String = ""
    
    
    func sendMessage() {
        let message = Message(text: messageFieldValue, isFromMe: true)
        
        messages.append(message)
        
        messageFieldValue = ""
        
        self.lastMessageId = message.id
    }
    
    // MARK: - Socket Handlers
    
    
    
    func handleIncomingChatMessage(_ socketMessage: SocketChatMessage) {
        // Convert socket message to our local Message type
        let newMessage = Message(text: socketMessage.Message, isFromMe: false)
        
        // Append to UI list
        messages.append(newMessage)
        
        // Ensure scroll to bottom
        self.lastMessageId = newMessage.id
    }
    
    func handleIncomingNotification(_ notification: NotificationEvent) {
        // Only handle specific "message" type notifications if needed
        // Or simply append the message if it's broad
        if notification.data.notificationType == "message" {
            let newMessage = Message(text: notification.data.Message, isFromMe: false)
            messages.append(newMessage)
            self.lastMessageId = newMessage.id
        }
    }
}

