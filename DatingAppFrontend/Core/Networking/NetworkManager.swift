//
//  NetworkManager.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 21/01/26.
//

import Foundation
import PhotosUI

// NetworkManager.swift

actor NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://prettying-randell-ungrudgingly.ngrok-free.dev/api"
    
    // Dependency Injection: The Network Manager needs access to the Auth Store
    var tokenProvider: AuthViewModel?
    
    func setTokenProvider(_ provider: AuthViewModel) {
            self.tokenProvider = provider
        }

    
    
    func request<T: Decodable>(endpoint: APIEndpoint, body: Encodable? = nil) async throws -> T {
        
        // 1. Construct URL
        guard let url = await URL(string: baseURL + endpoint.path) else {
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = await endpoint.method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 2. Attach Token Automatically
        if let token = await tokenProvider?.authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // 3. Encode Body
        if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
        }
        
        // 4. Perform Request
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // ---------------- ADD THIS DEBUG BLOCK ----------------
//        if let jsonString = String(data: data, encoding: .utf8) {
//            print("🔴 ACTUAL SERVER RESPONSE: \(jsonString)")
//        }
        // ------------------------------------------------------
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        // 5. AUTOMATIC 401 HANDLING (The Magic Part) 🪄
        if httpResponse.statusCode == 401 {
            print("🔐 401 Detected in Network Layer...")
            
            if let provider = tokenProvider {
                do {
                    // Attempt to refresh the token.
                    // Since this is a throwing Void function, success means execution continues.
                    try await provider.refreshAuthToken()
                    
                    // B. Retry the EXACT same request recursively.
                    // Because 'provider' (AuthViewModel) now has the new authToken in memory,
                    // the recursive call will use the fresh token automatically.
                    print("🔄 Token refreshed, retrying original request...")
                    return try await self.request(endpoint: endpoint, body: body)
                    
                } catch {
                    // C. If refresh fails (e.g., refresh token is also expired),
                    // AuthViewModel has already handled logout() internally.
                    print("❌ Token refresh failed: \(error)")
                    throw error // Propagate the error (e.g., .unauthorized) to the ViewModel
                }
            }
            
            // Fallback if no provider is linked
            throw AuthNetworkError.unauthorized
        }
        
        // 6. Decode Success
          return try JSONDecoder().decode(T.self, from: data)
        
        // Debug:-
//        let finalResponse =  try JSONDecoder().decode(T.self, from: data)
//        print("Api Response:", finalResponse)
//        
//        return finalResponse
    }
    
    func upload<T: Decodable>(endpoint: APIEndpoint, parameters: [String: String], images: [UIImage]) async throws -> T {
        // 1. Construct URL
        guard let url = await URL(string: baseURL + endpoint.path) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // 2. Setup Boundary and Headers
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        if let token = await tokenProvider?.authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // 3. Construct Multipart Body
        
        var body = Data()
        
        // Append Text Parameters
        for (key, value) in parameters {
            body.append(Data("--\(boundary)\r\n".utf8))
            body.append(Data("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".utf8))
            body.append(Data("\(value)\r\n".utf8))
        }
        
        // Append Images
        for (index, image) in images.enumerated() {
            if let imageData = image.jpegData(compressionQuality: 0.7) {
                body.append(Data("--\(boundary)\r\n".utf8))
                body.append(Data("Content-Disposition: form-data; name=\"proofs\"; filename=\"proof\(index).jpg\"\r\n".utf8))
                body.append(Data("Content-Type: image/jpeg\r\n\r\n".utf8))
                body.append(imageData)
                body.append(Data("\r\n".utf8))
            }
        }
        
        body.append(Data("--\(boundary)--\r\n".utf8)) // Final closing boundary
        request.httpBody = body
        
        // 4. Perform Request and Handle 401 (Reusing your logic)
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        // Automatic 401 Handling
        if httpResponse.statusCode == 401 {
            if let provider = tokenProvider {
                try await provider.refreshAuthToken()
                return try await self.upload(endpoint: endpoint, parameters: parameters, images: images)
            }
            throw AuthNetworkError.unauthorized
        }
        
//        return try JSONDecoder().decode(T.self, from: data)
        let finalresponse = try JSONDecoder().decode(T.self, from: data)
        print("APi response from network manager:",response)
        return finalresponse
    }
    
    
//    func uploadReport(toUserId: String, reason: String, comments: String, status: String, images: [UIImage]) async throws -> Bool {
//        guard let url = URL(string: baseURL + "/report") else { throw URLError(.badURL) }
//        
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        
//        let boundary = "Boundary-\(UUID().uuidString)"
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//        
//        // Auth Token logic reused from your current manager
//        if let token = await tokenProvider?.authToken {
//            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        }
//        
//        var body = Data()
//        
//        // 1. Text Fields (Matching your sample keys)
//        let textFields = [
//            "ToUserId": toUserId,
//            "Reason": reason,
//            "Comments": comments,
//            "Status": status
//        ]
//        
//        for (key, value) in textFields {
//            body.append(Data("--\(boundary)\r\n".utf8))
//            body.append(Data("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".utf8))
//            body.append(Data("\(value)\r\n".utf8))
//        }
//        
//        // 2. File Field (Matching your key: FileProof)
//        for (index, image) in images.enumerated() {
//            if let imageData = image.jpegData(compressionQuality: 0.8) {
//                body.append(Data("--\(boundary)\r\n".utf8))
//                // Use FileProof as the key from your sample
//                body.append(Data("Content-Disposition: form-data; name=\"FileProof\"; filename=\"proof_\(index).jpg\"\r\n".utf8))
//                body.append(Data("Content-Type: image/jpeg\r\n\r\n".utf8))
//                body.append(imageData)
//                body.append(Data("\r\n".utf8))
//            }
//        }
//        
//        body.append(Data("--\(boundary)--\r\n".utf8))
//        request.httpBody = body
//        
//        let (_, response) = try await URLSession.shared.data(for: request)
//        return (response as? HTTPURLResponse)?.statusCode == 200
//    }
}






