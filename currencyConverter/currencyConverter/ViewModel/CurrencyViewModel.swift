//
//  CurrencyViewModel.swift
//  currencyConverter
//
//  Created by Yeseul Jang on 2/19/26.
//
class CurrencyViewModel {
    let networkManager = NetworkManager()
    var selectedCountry = "KRW"
    var rates = [String: Double]()
    var upDate: (([Item]) -> Void)?
    
    func fetchCurrencyData() {
        Task {
            do {
                let result: ExchangeRateResponse = try await networkManager.makeRequest(with: selectedCountry)
                let items = result.rates.map {(currency, rate) in
                    Item(currency: currency, rate: String(rate))
                }
                
                self.upDate?(items)
            }
        }
        
    }
}
