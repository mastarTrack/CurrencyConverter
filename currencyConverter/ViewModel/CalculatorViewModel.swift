//
//  CalculatorViewModel.swift
//  currencyConverter
//
//  Created by 손영빈 on 2/13/26.
//

//TODO: 0,음수일 때 에러처리

import Foundation

class CalculatorViewModel {
    
    var updateData: ((String) -> Void)?
    var showError: ((String) -> Void)?
    
    let item: ExchangeRate
    
    init(item: ExchangeRate) {
        self.item = item
    }
    
    func inputText(inputText: String?) {
        guard let text = inputText, !text.isEmpty else {
            showError?("금액을 입력해주세요")
            return
        }
        guard let amount = Double(text) else {
            showError?("올바른 숫자를 입력해주세요")
            return
        }
        if amount <= 0 {
            showError?("금액은 1보다 작을 수 없습니다.")
            return
        }
        let convertedValue = amount * item.rate
        let exchangeResult = String(format: "%.2f", convertedValue)
        let result = "$\(amount) → \(exchangeResult) \(item.code)"
        updateData?(result)
    }
}
