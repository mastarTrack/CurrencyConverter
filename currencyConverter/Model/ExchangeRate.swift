//
//  ExchangeRate.swift
//  currencyConverter
//
//  Created by 손영빈 on 2/13/26.
//

import Foundation

struct ExchangeRate {
    let code: String
    let rate: Double
    var status: RateStatus = .stay
    
    func getCountry(code: String) -> String {
        return Mapper.getName(code: code)
    }
}

enum RateStatus {
    case up, down, stay
}
