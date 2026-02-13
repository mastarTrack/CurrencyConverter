//
//  ExchangeRateViewModel.swift
//  currencyConverter
//
//  Created by 손영빈 on 2/13/26.
//

import Foundation
import Alamofire

class ExchangeRateViewModel {
    
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
                allData = sortedRates.map { ExchangeRate(code: $0.key, rate: $0.value) }
                viewData = allData
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
                let countryName = Mapper.getName(code: item.code)
                return item.code.uppercased().contains(searchText.uppercased()) || countryName.contains(searchText)
            }
        }
    }
    
}
