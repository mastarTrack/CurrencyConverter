//
//  MainViewModel.swift
//  currencyConverter
//
//  Created by t2025-m0143 on 2/23/26.
//

import UIKit

class MainViewModel: ViewModelProtocol {
    var update: (([Rate]) -> Void)?
    var state: AlertType?
    
    private let dataService = DataService()
    
    private var originData: [Rate]? // 원본 데이터
    private var showingData: [Rate]? {
        didSet {
            update?(showingData ?? [])
        }
    } // 컬렉션뷰에 표시중인 데이터
    
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
    
    // 데이터 검색
    func searchData(_ text: String) {
        if text.isEmpty { // 검색어가 비었을 경우
            showingData = originData
        } else { // 검색어가 있을 경우
            showingData = originData?.filter {
                $0.currencyCode.contains(text.uppercased()) ||
                $0.country.contains(text)
            }
        }
    }
    
    // 컬렉션뷰 셀 설정에 필요한 데이터 전달
    func fetchRateStringData(of index: IndexPath) -> (String, String, String) {
        let rate = showingData?[index.row]
        guard let rate else { return ("", "", "") }
        
        let value = String(format: "%.4f", rate.value)
        return (rate.currencyCode, rate.country, value)
    }
    
    func fetchRateData(of index: IndexPath) -> Rate? {
        return showingData?[index.row]
    }
}
