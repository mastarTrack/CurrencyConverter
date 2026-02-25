//
//  NetworkManager.swift
//  currencyConverter
//
//  Created by 손영빈 on 2/24/26.
//

import Foundation
import Alamofire

class NetworkManager {
    
    // 성공했을 경우: 정상데이터, 실패했을 경우 아래의 let 구문이 실행되어 result: Error 타입으로 제공
    func fetchData<T: Decodable>(url: URL, completion: @escaping(Result<T,Error>) -> Void) {
        AF.request(url).responseDecodable(of: T.self) { response in
            let result = response.result.mapError { $0 as Error } // mapError 내부의 값이 Error라면 실행
            completion(result)
        }
    }
}
