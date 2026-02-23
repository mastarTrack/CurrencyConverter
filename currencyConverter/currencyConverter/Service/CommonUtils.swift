//
//  CommonUtils.swift
//  currencyConverter
//
//  Created by Hanjuheon on 2/23/26.
//

import Foundation

class CommonUtils {
     static func formatCurrency(rate: Double, isoCode: String) -> String {
       let formatter = NumberFormatter()
       formatter.numberStyle = .currency
       formatter.currencyCode = isoCode
       formatter.locale = Locale.current
       
       return formatter.string(from:  NSNumber(value: rate)) ?? "--"
   }
}
