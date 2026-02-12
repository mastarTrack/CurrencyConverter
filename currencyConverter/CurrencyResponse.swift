//
//  CurrencyResponse.swift
//  currencyConverter
//
//  Created by 손영빈 on 2/12/26.
//

import Foundation

class CurrencyResponse: Codable {
    let rates: [String: Double]
}
