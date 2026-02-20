//
//  NetworkManager.swift
//  currencyConverter
//
//  Created by Yeseul Jang on 2/20/26.
//
import Foundation

class NetworkManager: Networking {
    func makeRequest(with selectedCountry: String) async throws -> ExchangeRateResponse {
        var components = URLComponents()
        components.scheme = "ht1tps"
        components.host = "open.er-api.com"
        components.path = "/v6/latest/\(selectedCountry)"
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        return try await fetchData(url: url)
    }
    
    func fetchData<T:Decodable>(url: URL) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        let successRange = 200..<300
        
        guard let response = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard successRange ~= response.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}


protocol Networking {
    func makeRequest(with selectedCountry: String) async throws -> ExchangeRateResponse
    
    func fetchData<T:Decodable>(url: URL) async throws -> T
}
