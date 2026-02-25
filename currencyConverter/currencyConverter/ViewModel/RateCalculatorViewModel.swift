//
//  RateCalculatorViewModel.swift
//  currencyConverter
//
//  Created by Yeseul Jang on 2/23/26.
//
import Foundation

class RateCalculatorViewModel {
    private let selectedItem: Item
    
    var item: Item { selectedItem } // 접근용 파라미터
    
    init(selectedItem: Item) {
        self.selectedItem = selectedItem
    }
    
    func calculate(input: String) throws -> String {
        guard !input.isEmpty else { throw CalculatorError.NoInput }
        
        guard let amount = Double(input) else {
            throw CalculatorError.invalidInput
        }
        
        let rate = Double(item.rate) ?? 0
        let result = amount * rate
        return String(format: "%.2f", result)
    }
}

enum CalculatorError: LocalizedError {
    case invalidInput
    case NoInput

    var errorDescription: String? {
        switch self {
        case .invalidInput:
            return "숫자만 입력해주세요."
        case .NoInput:
            return "금액을 입력하세요."
        }
    }
}
