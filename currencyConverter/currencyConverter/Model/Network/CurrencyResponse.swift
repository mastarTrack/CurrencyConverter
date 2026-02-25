//
//  CurrencyResponse.swift
//  currencyConverter
//
//  Created by t2025-m0143 on 2/19/26.
//
import Foundation

struct CurrencyResponse: Codable {
    let rates: [String: Double]
    let lastUpdate: Date
    let nextUpdate: Date
    
    enum CodingKeys: String, CodingKey {
        case rates
        case lastUpdate = "time_last_update_unix"
        case nextUpdate = "time_next_update_unix"
    }
}
