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
    private let coreDataManager = CoreDataManager()
    
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
}

//MARK: 환율 데이터 설정 및 검색
extension MainViewModel {
    // 초기 데이터 설정
    func fetchData() {
        let codes = coreDataManager.loadAllBookMark() ?? []
        
        // 환율 데이터 설정
        dataService.fetchCurrencyData(currency: "USD") {[weak self] result in
            guard let self else { return }
            guard let result else {
                self.dataStatus = .emptyData
                return
            }
            
            let rates = result.rates.reduce(into: []) {
                $0.append(Rate(currencyCode: $1.key, value: $1.value, bookMarked: codes.contains($1.key)))
            }

            self.originData = rates
            self.observedData = sortData(data: rates)
        }
    }
    
    // 데이터 검색
    func searchData(_ text: String) {
        if text.isEmpty { // 검색어가 비었을 경우
            observedData = sortData(data: originData ?? [])
        } else { // 검색어가 있을 경우
            let data = originData?.filter {
                $0.currencyCode.contains(text.uppercased()) ||
                $0.country.contains(text)
            } ?? []
            
            observedData = sortData(data: data)
        }
    }
    
    // 컬렉션뷰 셀 설정에 필요한 데이터 전달
    func fetchValueStringData(of data: Rate) -> String {
        let value = String(format: "%.4f", data.value)
        return value
    }
    
    // 북마크 여부 업데이트
    func updateBookMark(of rate: Rate, to bookMarked: Bool) {
        guard let i = originData?.firstIndex(of: rate) else { return }
        originData?[i].bookMarked = bookMarked
        
        observedData = sortData(data: observedData ?? [])
    }
}

//MARK: CoreData
extension MainViewModel {
    func saveBookMark(_ data: Rate) {
        coreDataManager.saveBookMark(data.currencyCode)
    }
    
    func deleteBookMark(_ data: Rate) {
        coreDataManager.deleteBookMark(data.currencyCode)
    }
    
    func deleteAllBookMark() {
        coreDataManager.deleteAllBookMark()
    }
    
    private func sortData(data: [Rate]) -> [Rate] {
        data.sorted {
            if $0.bookMarked || $1.bookMarked { // 둘 중 하나가 bookMark일 경우
                return $0.bookMarked ? true : false
            } else {
                return $0.currencyCode < $1.currencyCode
            }
        }
    }
}
