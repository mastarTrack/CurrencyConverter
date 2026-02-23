//
//  RateCalculatorViewModel.swift
//  currencyConverter
//
//  Created by Yeseul Jang on 2/23/26.
//
import Foundation

class RateCalculatorViewModel {
    private let selectedItem: Item
    
    var item: Item { selectedItem }
    
    init(selectedItem: Item) {
        self.selectedItem = selectedItem
    }
    
    func calculate(amountText: String) -> String {
        guard let amount = Double(amountText) else { return "0"}
        let rate = Double(item.rate) ?? 0
        
        let result = amount * rate
        
        return String(format: "%.2f", result)
    }
}
