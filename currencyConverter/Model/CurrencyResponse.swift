//
//  CurrencyResponse.swift
//  currencyConverter
//
//  Created by 손영빈 on 2/12/26.
//

import Foundation

struct CurrencyResponse: Codable {
    let rates: [String: Double]
    let unix: Int64 // 최근 업데이트 받은 정보
    
    enum CodingKeys: String, CodingKey {
        case rates
        case unix = "time_last_update_unix"
    }
}
