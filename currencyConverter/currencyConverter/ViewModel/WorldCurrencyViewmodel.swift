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
    private var manager = WorldCurrencyManager()
    private var apiService = APIService()
    private(set) var datas: [CurrencyData] = []
    
    //MARK: - Closures
    var updateCurrencyClosure: (()->Void)?

}

extension WorldCurrencyViewmodel {
    func fatchModelToSearch(searchText: String) {
        datas = searchText.isEmpty ? manager.worldCurrencyDatas : manager.worldCurrencyDatas.filter{
            $0.isoCode.lowercased().contains(searchText.lowercased()) || $0.countryName.contains(searchText)
        }
    }
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
                datas = manager.worldCurrencyDatas
                DispatchQueue.main.async {
                    self.updateCurrencyClosure?()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
