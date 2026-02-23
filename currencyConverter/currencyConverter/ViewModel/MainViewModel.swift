//
//  MainViewModel.swift
//  currencyConverter
//
//  Created by t2025-m0143 on 2/23/26.
//

import UIKit

class MainViewModel: ViewModelProtocol {
    var action: ((@escaping () -> ([Rate], AlertType?)) -> Void)?
    var update: (([Rate]) -> Void)?
    var state: AlertType?
    
    private let dataService = DataService()
    private var originData: [Rate]? {
        didSet {
            update?(originData ?? [])
        }
    } // 원본 데이터
    private var showingData: [Rate]? // 컬렉션뷰에 표시중인 데이터
    private var dataStatus: AlertType?
    
    // 초기 데이터 설정
    func fetchData() {
        dataService.fetchCurrencyData(currency: "USD") { result in
            guard let result else {
                self.dataStatus = .emptyData
                return
            }
            
            let rates = result.rates.reduce(into: []) {
                $0.append(Rate(currencyCode: $1.key, value: $1.value))
            }
            
            self.originData = rates
            self.showingData = self.originData
        }
    }
}
