//
//  ExchangeRateViewModel.swift
//  currencyConverter
//
//  Created by 손영빈 on 2/13/26.
//

//TODO: FavoriteManager 연결, starButton 클릭시 호출 메서드 생성, 좋아요 기준 정렬 메서드 생성

import Foundation
import Alamofire

class ExchangeRateViewModel {
    
    var historyManager: HistoryManager?
    
    var favoriteManager: FavoriteManager?
    var favoriteList: [Favorite] = []
    
    var updateData: (() -> Void)?
    
    var allData: [ExchangeRate] = []
    var viewData: [ExchangeRate] = [] {
        didSet { // viewData 변경 시 바인딩
            updateData?()
        }
    }
    
    var dataCount: Int {
        return viewData.count
    }
    
    var isDataEmpty: Bool {
        return viewData.isEmpty
    }
    
    func getItem(index: Int) -> ExchangeRate {
        return viewData[index]
    }
    
    private func fetchData<T: Decodable>(url: URL, completion: @escaping(Result<T,AFError>) -> Void) {
        AF.request(url).responseDecodable(of: T.self) { response in
            completion(response.result)
        }
    }
    
    func getCurrencyData() {
        guard let url = URL(string: "https://open.er-api.com/v6/latest/USD") else {
            print("잘못된 URL")
            return
        }
        fetchData(url: url) { [weak self] (result: Result<CurrencyResponse,AFError>) in
            guard let self else { return }
            switch result {
            case .success(let result):
                let sortedRates = result.rates.sorted{ $0.key < $1.key }
                let currentUnix = result.unix
                allData = sortedRates.map { code, rate in
                    let lastData = self.historyManager?.fetchData(code: code)
                    var exchangeRate = ExchangeRate(code: code, rate: rate)
                    if let last = lastData, last.unix != Int64(currentUnix) {
                        let diff = rate - last.rate
                        if diff > 0.01 {
                            exchangeRate.status = .up
                        } else if diff < -0.01 {
                            exchangeRate.status = .down
                        }
                    }
                    return exchangeRate
                }
                viewData = allData
                sortByFavorite()
                self.historyManager?.saveData(rates: result.rates, unix: Int64(currentUnix))
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func search(searchText: String) {
        if searchText.isEmpty {
            viewData = allData
        } else {
            viewData = allData.filter { item in
                let isCodeEqual = item.code.uppercased().contains(searchText.uppercased())
                let isCountryEqaul = item.getCountry(code: item.code).contains(searchText)
                return isCodeEqual || isCountryEqaul
            }
        }
        sortByFavorite()
    }
    
    // 좋아요 기준으로 정렬하는 메서드
    func sortByFavorite() {
        self.favoriteList = favoriteManager?.fetchFavorites() ?? []
        let codes = favoriteList.map { $0.code }
        self.viewData.sort { a, b in
            let isAFavorite = codes.contains(a.code)
            let isBFavorite = codes.contains(b.code)
            if isAFavorite != isBFavorite {
                return isAFavorite
            }
            return a.code < b.code
        }
    }
    
    func toggleFavorite(code: String) {
        favoriteManager?.toggleFavorite(code: code)
        sortByFavorite()
    }
    
    func isFavorite(code: String) -> Bool {
        return favoriteList.contains { $0.code == code}
    }
}
