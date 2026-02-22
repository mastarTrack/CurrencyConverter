//
//  ExchangeRateViewModel.swift
//  currencyConverter
//
//  Created by 김주희 on 2/17/26.
//

import Foundation

class ExchangeRateViewModel: ViewModelProtocol {
    
    // MARK: -- Action, State 정의
    // VC -> VM
    enum Action {
        case viewDidLoad // 화면 켜졌을때 데이터 가져오기
        case filter(text: String) // 검색창의 텍스트 필터링
    }
    
    // VM -> VC
    enum State {
        case none
        case success(rates: [SimpleRate])
        case error(message: String)
    }
    
    // VC에게 알림 줄 클로저
    var stateChanged: ((State) -> Void)?

    var state: State = .none { // 초기 상태 none
        didSet {
            // 상태가 바뀔때마다 VC에게 새로운 상태 던짐
            stateChanged?(state)
        }
    }
    
    lazy var action: ((Action) -> Void)? = { [weak self] action in
        switch action {
            
        case .viewDidLoad:
            self?.fetchRates()
            
        case .filter(let text):
            self?.filterRates(searchText: text)
        }
    }
    
    
    // MARK: -- 데이터 담을 것 정의
    // 테이블뷰 cell에 얹을 데이터 구조체 (통화코드, 환율값)
    struct SimpleRate {
        let currencyCode: String
        let rate: Double
    }
    
    // 원본 rates
    var rates: [SimpleRate] = []

    
    // MARK: -- 데이터 가져오는 메서드
    private func fetchRates() {
        NetworkManager.shared.fetchRates { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                // Dictionary를 Array로 변환함
                let sortedRates = response.rates.map { key, value in
                    return SimpleRate(currencyCode: key, rate: value)
                }.sorted { $0.currencyCode < $1.currencyCode }
                
                self.rates = sortedRates
                
                // state => success
                self.state = .success(rates: sortedRates)
                
            case .failure(_):
                
                // state => error
                self.state = .error(message: "데이터를 불러올 수 없습니다.") // 에러 발생시에 VC에 알림
            }
        }
    }
    
    // MARK: -- 데이터 필터링 메서드
    private func filterRates(searchText: String) {
        if searchText.isEmpty { // 검색창이 비었을때
            self.state = .success(rates: rates) // 원본 전송
        } else {
            let filteredRates = rates.filter { item in
                
                // 통화 코드가 검색어를 포함하는지
                let isCodeMatch = item.currencyCode.lowercased().contains(searchText.lowercased())
                
                // 국가명이 검색어를 포함하는지
                let countryName = CountryDictionary.countryDictionary[item.currencyCode] ?? ""
                let isCountryMatch = countryName.contains(searchText)
                
                // 둘중에 하나라도 만족하면 true 반환
                return isCodeMatch || isCountryMatch
            }
            
            self.state = .success(rates: filteredRates)
        }
    }
}
