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
    
    func getCountry() -> String {
        return Mapper.getName(code: code)
    }
}
