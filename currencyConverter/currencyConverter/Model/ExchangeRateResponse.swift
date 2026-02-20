//
//  ExchangeRateResponse.swift
//  currencyConverter
//
//  Created by Yeseul Jang on 2/20/26.
//

struct ExchangeRateResponse: Decodable {
    let result: String
    let baseCode: String
    let rates: [String: Double]
    
    enum CodingKeys: String, CodingKey {
        case result
        case baseCode = "base_code"
        case rates
    }
}
