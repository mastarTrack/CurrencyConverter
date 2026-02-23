//
//  CommonUtils.swift
//  currencyConverter
//
//  Created by Hanjuheon on 2/23/26.
//

import Foundation

class CommonUtils {
    /// isoCode값에 해당하는 국가 통화 텍스트로 전환 해주는 메소드
    static func formatCurrency(rate: Double, isoCode: String, digit: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = isoCode
        formatter.locale = Locale.current
        
        formatter.minimumFractionDigits = digit
        formatter.maximumFractionDigits = digit
        
        return formatter.string(from:  NSNumber(value: rate)) ?? "--"
    }
}
