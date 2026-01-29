//
//  NetworkManager.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 21/01/26.
//

import Foundation

// NetworkManager.swift
actor NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://datolitic-unprejudiced-lawson.ngrok-free.dev/api"
    
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
//          return try JSONDecoder().decode(T.self, from: data)
        
        // Debug:-
        let finalResponse =  try JSONDecoder().decode(T.self, from: data)
        print("Api Response:", finalResponse)
        
        return finalResponse
    }
}
