//
//  CurrencyViewModel.swift
//  currencyConverter
//
//  Created by Yeseul Jang on 2/19/26.
//
import Foundation

class CurrencyViewModel {
    let networkManager = NetworkManager()
    var selectedCountry = "KRW"
    var rates = [String: Double]()
    var upDate: (([Item]) -> Void)?
    var onError: ((String) -> Void)?
    
    func fetchCurrencyData() {
        Task {
            do {
                let result: ExchangeRateResponse =
                try await networkManager.makeRequest(with: selectedCountry)
                
                if result.rates.isEmpty {
                    onError?("데이터를 불러올 수 없습니다")
                    return
                }
                
                let items = result.rates.map {(currency, rate) in
                    Item(
                        currency: currency,
                        rate: String(format: "%.4f", rate))
                }
                
                self.upDate?(items)
                
            } catch {
                onError?("데이터를 불러올 수 없습니다")
            }
        }
        
    }
}
