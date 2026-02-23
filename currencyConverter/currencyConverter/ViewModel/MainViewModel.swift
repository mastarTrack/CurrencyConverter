//
//  MainViewModel.swift
//  currencyConverter
//
//  Created by t2025-m0143 on 2/23/26.
//

import UIKit

final class MainViewModel: ViewModelProtocol {
    var update: (([Rate]) -> Void)?
    var alert: ((AlertType) -> Void)?
    
    private let dataService = DataService()
    
    private var originData: [Rate]? // 원본 데이터
    private(set) var observedData: [Rate]? { // 컬렉션뷰에 표시중인 데이터
        didSet {
            update?(observedData ?? [])
        }
    }
    
    private var dataStatus: AlertType? { // alert 타입
        didSet {
            alert?(dataStatus ?? .emptyData)
        }
    }
    
    // 이니셜라이저
    init() {
        fetchData()
    }
    
    // 초기 데이터 설정
    func fetchData() {
        dataService.fetchCurrencyData(currency: "USD") { result in
            guard let result else {
                self.dataStatus = .emptyData
                return
            }
            
            let rates = result.rates.reduce(into: []) {
                $0.append(Rate(currencyCode: $1.key, value: $1.value))
            }.sorted { $0.currencyCode < $1.currencyCode }
            
            self.originData = rates
            self.observedData = self.originData
        }
    }
    
    // 데이터 검색
    func searchData(_ text: String) {
        if text.isEmpty { // 검색어가 비었을 경우
            observedData = originData
        } else { // 검색어가 있을 경우
            observedData = originData?.filter {
                $0.currencyCode.contains(text.uppercased()) ||
                $0.country.contains(text)
            }
        }
    }
    
    // 컬렉션뷰 셀 설정에 필요한 데이터 전달   
    func fetchRateStringData(of data: Rate) -> (String, String, String) {
        let value = String(format: "%.4f", data.value)
        return (data.currencyCode, data.country, value)
    }
    
    func fetchRateData(of index: IndexPath) -> Rate? {
        return observedData?[index.row]
    }
}
