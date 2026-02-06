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
    private var currentUserId: Int?
    let session = URLSession(configuration: .default)
    
    func connect(userId: Int) {
        if webSocketTask?.state == .running && currentUserId == userId {
            print("ℹ️ Socket already running for userId: \(userId)")
            return
        }
        
        self.currentUserId = userId
        guard let url = URL(string: "ws://prettying-randell-ungrudgingly.ngrok-free.dev/ws?userId=\(userId)") else{
            print("❌ Error constructing socket URL")
            return
        }
        
        webSocketTask = session.webSocketTask(with: url)
        
        webSocketTask?.resume()
        print("🟢 Socket connecting for userId: \(userId)...")
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
                            formatter.locale = .init(identifier: "en_US_POSIX")
                            formatter.timeZone = TimeZone(secondsFromGMT: 0)

                            decoder.dateDecodingStrategy = .custom { decoder in
                                let container = try decoder.singleValueContainer()
                                let dateString = try container.decode(String.self)
                                
                                let formats = [
                                    "yyyy-MM-dd'T'HH:mm:ss.SSSSSSS'Z'",
                                    "yyyy-MM-dd'T'HH:mm:ss.SSSSSSS",
                                    "yyyy-MM-dd'T'HH:mm:ss.SSS",
                                    "yyyy-MM-dd'T'HH:mm:ss.SS",
                                    "yyyy-MM-dd'T'HH:mm:ss",
                                    "dd MMM yyyy, hh:mm a"
                                ]
                                
                                for format in formats {
                                    formatter.dateFormat = format
                                    if let date = formatter.date(from: dateString) {
                                        return date
                                    }
                                }
                                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string \(dateString)")
                            }

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
                                
                            } else if let msgType = envelope.type, !msgType.isEmpty {
                                // If it has a 'type' (e.g., "Text"), it's likely a regular incoming message
                                let receivedMessage = try decoder.decode(SocketReceivedMessage.self, from: data)
                                print("📩 Received message from other:", receivedMessage.content)
                                self.onReceivedMessage?(receivedMessage)
                                
                            } else {
                                // Likely a PascalCase Sent Acknowledgment (no 'type' field, uses 'MessageType' usually)
                                let ackMessage = try decoder.decode(SocketChatMessage.self, from: data)
                                print("✅ Sent Ack received for:", ackMessage.Message)
                                self.onChatMessageReceived?(ackMessage)
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
                    if let userId = self.currentUserId {
                        self.connect(userId: userId)
                    }
                }
            }
        }
    }
    
    func disconnect() {
            webSocketTask?.cancel(with: .goingAway, reason: nil)
            webSocketTask = nil
        }
    
    func sendMessage(payload: Encodable) {
        do {
            let data = try JSONEncoder().encode(payload)
            if let jsonString = String(data: data, encoding: .utf8) {
                let message = URLSessionWebSocketTask.Message.string(jsonString)
                webSocketTask?.send(message) { error in
                    if let error = error {
                        print("❌ Failed to send message: \(error)")
                    } else {
                        print("✅ Message sent: \(jsonString)")
                    }
                }
            }
        } catch {
            print("❌ Failed to encode payload: \(error)")
        }
    }
    
    
    var onChatMessageReceived: ((SocketChatMessage) -> Void)?
    var onReceivedMessage: ((SocketReceivedMessage) -> Void)?
    var onNotificationReceived: ((NotificationEvent) -> Void)?
    var onMatchStatusReceived: ((MatchStatusEvent) -> Void)?

}


