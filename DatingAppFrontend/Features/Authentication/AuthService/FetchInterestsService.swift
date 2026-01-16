//
//  FetchInterestsService.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 16/01/26.
//

import Foundation

class FetchInterestsService{
    let baseUrl = "https://datolitic-unprejudiced-lawson.ngrok-free.dev/api"
    
    func fetchOptionsForInterests(endpoint: String, token: String) async throws -> [InterestOption]{
        guard let url = URL(string: baseUrl + endpoint) else{
            throw URLError(.badURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        
        if let http = response as? HTTPURLResponse {
                   print("STATUS:", http.statusCode)
               }
        
        let decoded = try JSONDecoder().decode(InterestResponse.self, from: data)
        return decoded.data.interst
        
    }
}
