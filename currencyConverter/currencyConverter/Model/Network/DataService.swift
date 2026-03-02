//
//  DataService.swift
//  currencyConverter
//
//  Created by t2025-m0143 on 2/19/26.
//
import Alamofire
import Foundation

class DataService {
    
    private func fetchData<T: Decodable>(url: URL, completion: @escaping (Result<T, AFError>) -> Void) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        AF.request(url).responseDecodable(of: T.self, decoder: decoder) { response in
            completion(response.result)
        }
    }
    
    func fetchCurrencyData(currency: String, completion: @escaping (CurrencyResponse?) -> Void) {
        var urlComp = URLComponents(string: "https://open.er-api.com/v6/latest/")
        urlComp?.path.append(currency)
        
        guard let url = urlComp?.url else { return }

        fetchData(url: url) { (response: Result<CurrencyResponse, AFError>) in
            switch response {
            case .success(let result):
                completion(result)
            case .failure:
                completion(nil)
            }
        }
    }
}
