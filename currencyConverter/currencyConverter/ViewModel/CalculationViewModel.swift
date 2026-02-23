//
//  CalculationViewModel.swift
//  currencyConverter
//
//  Created by t2025-m0143 on 2/23/26.
//

class CalculationViewModel: ViewModelProtocol {
    var update: (([Rate]) -> Void)?
    var alert: ((AlertType) -> Void)?
    
    private var rate: Rate!
    private(set) var observedData: [Rate]? {
        didSet {
            update?(observedData ?? [])
        }
    }
    
    // 초기 데이터 설정
    func setInitialData(_ data: Rate) {
        rate = data
    }
    
    func fetchData() -> Rate {
        return rate
    }
}
