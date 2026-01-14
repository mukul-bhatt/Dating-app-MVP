//
//  MasterOptionsService.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 14/01/26.
//

import Foundation

class MasterOptionsService{
    let baseUrl = "https://datolitic-unprejudiced-lawson.ngrok-free.dev/api"
    
    func fetchOptions(endpoint: String, token: String) async throws -> [LookUpOption] {
        guard let url = URL(string: baseUrl+endpoint) else{
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
                request.httpMethod = "GET"
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let http = response as? HTTPURLResponse {
                   print("STATUS:", http.statusCode)
               }
        
        let decoded = try JSONDecoder().decode(MasterOptionsResponse.self, from: data)
        return decoded.options
    }
}
