//
//  ChatSocketManager.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 05/02/26.
//

import Foundation

@MainActor
class ChatSocketManager{
    static let shared = ChatSocketManager()
    
    private var webSocketTask: URLSessionWebSocketTask?
    let session = URLSession(configuration: .default)
    
    func connect() {
        guard let url = URL(string: "ws://prettying-randell-ungrudgingly.ngrok-free.dev/ws?userId=6017") else{
            print("❌ Error constructing socket URL")
            return
        }
        
        webSocketTask = session.webSocketTask(with: url)
        
        webSocketTask?.resume()
        print("🟢 Socket connecting...")
        listen()
        
    }
    
    func listen(){
        webSocketTask?.receive { [weak self] result in
            guard let self else { return }
            
            Task { @MainActor [self] in
                switch result {
                case .success(let message):
                    // Keep listening after success
                    defer { self.listen() }
                    
                    switch message {
                    case .string(let text):
                        print("Raw socket response:", text)
                        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)

                        guard trimmed.first == "{" else {
                            print("💓 Heartbeat:", trimmed)
                            return
                        }

                        guard let data = trimmed.data(using: .utf8) else { return }

                        do {

                            let decoder = JSONDecoder()

                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSS'Z'"
                            formatter.locale = .init(identifier: "en_US_POSIX")
                            formatter.timeZone = .current

                            decoder.dateDecodingStrategy = .formatted(formatter)

                            // 👇 Step 1: check if there's a `type`
                            let envelope = try decoder.decode(SocketTypeEnvelope.self, from: data)

                            if envelope.type == "notification" {

                                let notification = try decoder.decode(NotificationEvent.self, from: data)
                                print("🔔 Notification:", notification.data.Message)

                                self.onNotificationReceived?(notification)

                            } else if envelope.type == "match_status_list" {
                                
                                let matchStatus = try decoder.decode(MatchStatusEvent.self, from: data)
                                print("🔥 Match Status Update: \(matchStatus.users.count) users")
                                
                                self.onMatchStatusReceived?(matchStatus)
                                
                            } else {

                                let message = try decoder.decode(SocketChatMessage.self, from: data)
                                print("📩 Chat message:", message.Message)

                                self.onChatMessageReceived?(message)
                            }

                        } catch {
                            print("❌ Decode error:", error)
                        }


                    case .data(let data):
                        print("🔹 Received Data: \(data)")
                    @unknown default:
                        break
                    }

                case .failure(let error):
                    print("❌ Socket error: \(error). Reconnecting in 3 seconds...")
                    self.webSocketTask = nil
                    
                    // Reconnect after delay
                    try? await Task.sleep(nanoseconds: 3 * 1_000_000_000)
                    self.connect()
                }
            }
        }
    }
    
    func disconnect() {
            webSocketTask?.cancel(with: .goingAway, reason: nil)
            webSocketTask = nil
        }
    
    
    var onChatMessageReceived: ((SocketChatMessage) -> Void)?
    var onNotificationReceived: ((NotificationEvent) -> Void)?
    var onMatchStatusReceived: ((MatchStatusEvent) -> Void)?

}


