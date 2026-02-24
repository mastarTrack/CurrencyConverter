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
    
    func cancelSearch() {
        observedData = sortData(data: originData ?? [])
    }
    
    // 컬렉션뷰 셀 설정에 필요한 데이터 전달
    func fetchValueStringData(of data: Rate) -> String {
        let value = String(format: "%.4f", data.value)
        return value
    }
}

//MARK: CoreData
extension MainViewModel {
    // 북마크 여부 업데이트
    func updateBookMark(of rate: Rate, to bookMarked: Bool) {
        // 표시 데이터 변경
        guard let i = originData?.firstIndex(of: rate) else { return } // 데이터 찾기
        originData?[i].bookMarked = bookMarked // 북마크 값 변경
        
        observedData = sortData(data: observedData ?? []) // 표시 데이터 변경
        
        // 코어데이터 저장
        if bookMarked {
            coreDataManager.saveBookMark(rate.currencyCode)
        } else {
            coreDataManager.deleteBookMark(rate.currencyCode)
        }
    }
    
    // 데이터 정렬
    private func sortData(data: [Rate]) -> [Rate] {
        data.sorted {
            if $0.bookMarked && $1.bookMarked { // 두 값 모두 bookMark일 경우
                return $0.currencyCode < $1.currencyCode // 알파벳순 정렬
            } else if $0.bookMarked || $1.bookMarked { // 두 값 중 하나가 bookMark일 경우
                return $0.bookMarked ? true : false // 기준값이 bookMark이면 현재 순서 유지, 아니면 두 값 위치를 바꿈
            } else { // 두 값 모두 bookMark가 아닐 경우
                return $0.currencyCode < $1.currencyCode // 알파벳순 정렬
            }
        }
    }
}
