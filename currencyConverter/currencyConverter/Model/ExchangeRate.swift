//
//  ExchangeRate.swift
//  currencyConverter
//
//  Created by 김주희 on 2/17/26.
//
//
import Foundation

// API 전체 응답을 담는 구조체
struct ExchangeRateResponse: Codable {
    let result: String
    let baseCode: String
    let timeLastUpdateUtc: String
    let rates: [String: Double] // 통화코드(Key): 환율(Value)
    
    // JSON의 키값과 Swift 변수명이 다르므로 매핑해줘야됨
    enum CodingKeys: String, CodingKey {
        case result
        case baseCode = "base_code"
        case timeLastUpdateUtc = "time_last_update_utc"
        case rates
    }
}
