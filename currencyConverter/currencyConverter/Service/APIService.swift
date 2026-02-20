//
//  Untitled.swift
//  currencyConverter
//
//  Created by Hanjuheon on 2/20/26.
//

import Alamofire
import Foundation

class APIService {
    func fatchWorldCurrency<T: Decodable>(url: URL, completion: @escaping (Result<T, AFError>)-> Void) {
        AF.request(url).responseDecodable(of: T.self) { response in
            completion(response.result)
        }
    }
}

extension APIService {
    var baseURL: String {
        return "https://open.er-api.com/v6/latest/USD"
    }
}
