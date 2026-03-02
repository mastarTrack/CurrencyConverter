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
    
    // 테스트용
//    private let dataService = TestDataService()
//    private let coreDataManager = TestCoreDataManager()
    
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
}

//MARK: 환율 데이터 설정 및 검색
extension MainViewModel {
    // 초기 데이터 설정
    func setData() {
        guard let rates = coreDataManager.loadCurrencyData() else {
            // 저장된 데이터가 없을 경우
            print("1번째 환율 정보 API 호출")
            fetchData()
            return
        }
        
        guard let dates = coreDataManager.loadUpdateDate() else {
            print("날짜 정보 없음")
            return
        }
        
        if Date() < dates.nextUpdate { // 현재 날짜가 다음 업데이트 날짜보다 작을 경우
            // 기존 데이터 유지
            self.originData = rates
            self.observedData = sortData(data: rates)
        } else { // 현재 날짜가 다음 업데이트 날짜를 지났을 경우
            // 신규 데이터 호출
            print("신규 데이터 호출")
            fetchData(previous: rates)
        }
    }
    
    // API 호출하여 데이터 가져오기
    func fetchData(previous data: [Rate]? = nil) {
        // 환율 데이터 설정
        dataService.fetchCurrencyData(currency: "USD") {[weak self] result in
            guard let self else { return }
            guard let result else { // 결과가 없을 경우
                self.dataStatus = .emptyData // 오류 출력
                return
            }
            
            let rates = result.rates.reduce(into: [Rate]()) { arr, rates in
                guard let data else { // 기존 데이터가 없을 경우
                    arr.append(Rate(currencyCode: rates.key, value: rates.value, bookMarked: false))
                    return
                }
                
                // 기존 데이터가 있을 경우
                if let i = data.firstIndex(where: { $0.currencyCode == rates.key }) {
                    let fluctuation = data[i].value - rates.value
                    arr.append(Rate(currencyCode: rates.key, value: rates.value, bookMarked: data[i].bookMarked, fluctuation: fluctuation))
                } else {
                    arr.append(Rate(currencyCode: rates.key, value: rates.value, bookMarked: false))
                }
            }
            
            print(result.lastUpdate, result.nextUpdate)
            
            coreDataManager.saveCurrencyData(rates)
            coreDataManager.saveUpdateDate(lastUpdate: result.lastUpdate, nextUpdate: result.nextUpdate)

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
    func fetchValueStringData(of data: Rate) -> (String, String) {
        let value = String(format: "%.4f", data.value)
        
        let fluctuation = data.fluctuation
        let icon = abs(fluctuation) <= 0.01 ? "" : fluctuation > 0 ? "⬆️" : "⬇️"
        return (value, icon)
    }
}

//MARK: CoreData
extension MainViewModel {
    // 북마크 여부 업데이트
    func updateBookMark(of rate: Rate, to bookMarked: Bool) {
        // 표시 데이터 변경
        guard let i = originData?.firstIndex(of: rate) else { return } // 데이터 찾기
        originData?[i].bookMarked = bookMarked // 북마크 값 변경
        
        // 코어데이터 저장
        coreDataManager.updateBookMark(of: rate.currencyCode, bookMarked: bookMarked)
        
        // 표시 데이터 변경
        observedData = sortData(data: observedData ?? [])        
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
