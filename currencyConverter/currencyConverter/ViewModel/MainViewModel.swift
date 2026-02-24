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
    
    private(set) var bookMark: [String]? {
        didSet {
//            observedData = sortData(data: observedData ?? [], bookMark: bookMark ?? [])
            print(bookMark)
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
//                .sorted {
//                    if $0.bookMarked || $1.bookMarked { // 둘 중 하나가 bookMark일 경우
//                        return $0.bookMarked ? true : false
//                    } else {
//                        return $0.currencyCode < $1.currencyCode
//                    }
//                }
            self.originData = rates
            self.observedData = self.originData
//            
//            // 북마크 설정
//            bookMark = codes
        }
    }
    
    // 데이터 검색
    func searchData(_ text: String) {
        if text.isEmpty { // 검색어가 비었을 경우
            observedData = sortData(data: originData ?? [], bookMark: bookMark ?? [])
        } else { // 검색어가 있을 경우
            let data = originData?.filter {
                $0.currencyCode.contains(text.uppercased()) ||
                $0.country.contains(text)
            } ?? []
            print("searched : \(data)")
            
            observedData = sortData(data: data, bookMark: bookMark ?? [])
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
    }
}

//MARK: CoreData
extension MainViewModel {
    func saveBookMark(_ data: Rate) {
        coreDataManager.saveBookMark(data.currencyCode)
        bookMark = coreDataManager.loadAllBookMark() ?? [] // 현재 북마크
    }
    
    func deleteBookMark(_ data: Rate) {
        coreDataManager.deleteBookMark(data.currencyCode)
        bookMark = coreDataManager.loadAllBookMark() ?? []
    }
    
    func deleteAllBookMark() {
        coreDataManager.deleteAllBookMark()
        bookMark = coreDataManager.loadAllBookMark() ?? []
    }
    
    private func sortData(data: [Rate], bookMark: [String]) -> [Rate] {
        let codeData = data.map { $0.currencyCode }
        let bookMarkCodes = bookMark.filter { codeData.contains($0) }
        
        return data.sorted {
            if bookMarkCodes.contains($0.currencyCode) && bookMarkCodes.contains($1.currencyCode) { // 두 값 모두 bookMark 포함시
                return $0.currencyCode < $1.currencyCode // 알파벳순 정렬
            } else if bookMarkCodes.contains($0.currencyCode) || bookMark.contains($1.currencyCode) { // 하나만 bookMark 포함시
                // 기준값이 포함될 경우 순서 유지 (기준값을 앞에 두도록), 아닐 경우 순서 변경 (기준값이 뒤로 가도록)
                return bookMark.contains($0.currencyCode) ? true : false
            } else { // 두 값 모두 bookMark 미포함시
                return $0.currencyCode < $1.currencyCode // 알파벳순 정렬
            }
        }
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
