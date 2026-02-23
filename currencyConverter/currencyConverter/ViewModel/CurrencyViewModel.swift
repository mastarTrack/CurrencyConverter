//
//  CurrencyViewModel.swift
//  currencyConverter
//
//  Created by Yeseul Jang on 2/19/26.
//
import Foundation

class CurrencyViewModel {
    let networkManager = NetworkManager()
    var selectedCountry = "USD"
    var rates = [String: Double]()
    var upDate: (([Item]) -> Void)?
    var onError: ((String) -> Void)?
    var allItems = [Item]()
    
    func fetchCurrencyData() {
        Task {
            do {
                let result: ExchangeRateResponse =
                try await networkManager.makeRequest(with: selectedCountry)
                
                if result.rates.isEmpty {
                    onError?("데이터를 불러올 수 없습니다")
                    return
                }
                
                allItems = result.rates.map {(currency, rate) in
                    Item(
                        currency: currency,
                        country: result.currencyCountryMap[currency] ?? "unknow",
                        rate: String(format: "%.4f", rate))
                }
                
                self.upDate?(allItems)
                
            } catch {
                onError?("데이터를 불러올 수 없습니다")
            }
        }
    }
    
    func filterCurrency(with keyword: String) {
        if keyword.isEmpty {
            upDate?(allItems)
            return
        }
        
        let filteredItems = allItems.filter {
            $0.currency.lowercased().contains(keyword.lowercased())
        }
        
        upDate?(filteredItems)
    }
}
