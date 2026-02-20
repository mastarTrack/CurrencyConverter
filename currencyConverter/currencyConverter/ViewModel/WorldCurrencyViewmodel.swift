//
//  WorldCurrencyViewmodel.swift
//  currencyConverter
//
//  Created by Hanjuheon on 2/20/26.
//

import Alamofire
import Foundation

class WorldCurrencyViewmodel {
    
    //MARK: - Properties
    private(set) var manager = WorldCurrencyManager()
    private var apiService = APIService()
    
    //MARK: - Closures
    var updateCurrencyClosure: (()->Void)?

}

//MARK: - METHOD: Datafatch
extension WorldCurrencyViewmodel {
    func fatchWorldCurrency(){
        guard let url = URLComponents(string: apiService.baseURL)?.url else {
            fatalError("fatchWorldCurrency url Error")
        }
        apiService.fatchWorldCurrency(url: url) { [weak self] (result: Result<WorldCurrencyModel, AFError>) in
            guard let self else { return }
            switch result {
            case .success(let result):
                manager.updateData(model: result)
                DispatchQueue.main.async {
                    self.updateCurrencyClosure?()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
