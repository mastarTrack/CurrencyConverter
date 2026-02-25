//
//  CurrencyViewModel.swift
//  currencyConverter
//
//  Created by Yeseul Jang on 2/19/26.
//
import Foundation

class CurrencyViewModel {
    private let networkingService: Networking
    var selectedCountry = "USD"
    var rates = [String: Double]()
    var upDate: (([Item]) -> Void)?
    var onError: ((String) -> Void)?
    var allItems = [Item]()
    
    init(networkingService: Networking = NetworkManager()) {
        self.networkingService = networkingService
    }
    
    func fetchCurrencyData() {
        Task {
            do {
                let result: ExchangeRateResponse = try await networkingService.makeRequest(with: selectedCountry)
                
                if result.rates.isEmpty {
                    await MainActor.run {
                        self.onError?("데이터를 불러올 수 없습니다")
                    }
                    return
                }
                
                CoreDataManager.shared.upsertRates(result.rates)
                
                let items = result.rates.map { (currency, rate) in
                    Item(
                        currency: currency,
                        country: result.currencyCountryMap[currency] ?? "unknown",
                        rate: String(format: "%.4f", rate)
                    )
                }
                // UI 업데이트는 MainActor에서
                await MainActor.run {
                    self.allItems = items
                    self.upDate?(items)
                }
            } catch {
                await MainActor.run {
                    self.onError?("데이터를 불러올 수 없습니다")
                }
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
