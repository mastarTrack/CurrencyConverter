//
//  NetworkManager.swift
//  currencyConverter
//
//  Created by 김주희 on 2/17/26.
//

import Foundation
import Alamofire

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {} // 외부에서 또 다른 NetworkdManager() 만들지 못하게 막음
    
    // 서버에서 환율 데이터 가져오기
    func fetchRates(completion: @escaping (Result<ExchangeRateResponse, Error>) -> Void) {
        let url = "https://open.er-api.com/v6/latest/USD"
        
        // JSON 요청하기
        AF.request(url, method: .get)
            .validate() // 유효성 검사하기 (200번대 아니면 자동 실패 처리)
        // JSON을 Swift Struct 형태로 변환
            .responseDecodable(of: ExchangeRateResponse.self) { response in
                // 응답 처리하기
                switch response.result {
                case .success(let data):
                    // 성공하면 데이터 전달하기
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
