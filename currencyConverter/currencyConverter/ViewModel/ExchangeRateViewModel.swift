//
//  ExchangeRateViewModel.swift
//  currencyConverter
//
//  Created by 김주희 on 2/17/26.
//

import Foundation
import CoreData

class ExchangeRateViewModel: ViewModelProtocol {
    
    // MARK: -- Action, State 정의
    // VC -> VM
    enum Action {
        case viewDidLoad // 화면 켜졌을때 데이터 가져오기
        case filter(text: String) // 검색창의 텍스트 필터링
        case toggleFavorite(code: String)
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
            
        case .toggleFavorite(let code):
            self?.handleToggleFavorite(code: code)
        }
    }
    
    
    // MARK: -- 데이터 담을 것 정의
    // 테이블뷰 cell에 얹을 데이터 구조체 (통화코드, 환율값)
    struct SimpleRate {
        let currencyCode: String
        let rate: Double
        var isFavorite: Bool
        var upDown: String
    }
    
    // 원본 rates
    var rates: [SimpleRate] = []
    
    // 현 검색어 저장
    private var currentSearchText = ""

    // 즐겨찾기 된 코드 목록
    var favoriteCodes: [String] = []
    
    // 코어데이터 꺼내온 변수
    let context = CoreDataManager.shared.context
    
    
    // MARK: -- 데이터 가져오는 메서드
    private func fetchRates() {
        
        // 코어데이터 (즐찾 목록 배열) 가져오기
        do {
            let request = FavoriteCurrency.fetchRequest()
            let results = try context.fetch(request)
            self.favoriteCodes = results.compactMap { $0.favoriteCode }
        } catch {
            print("즐겨찾기 목록 불러오기 실패: \(error)")
        }
        
        // API 호출
        NetworkManager.shared.fetchRates { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                // Dictionary를 Array로 변환함
                let sortedRates = response.rates.map { key, value in
                    return SimpleRate(currencyCode: key, rate: value, isFavorite: self.favoriteCodes.contains(key), upDown: self.checkUpDownUpdateCache(code: key, newRate: value, newTime: Int64(response.timeLastUpdateUtc) ?? 0))
                }.sorted { $0.currencyCode < $1.currencyCode }
                
                self.rates = sortedRates // 정렬한 데이터 (배열) 대입
                
                // 즐겨찾기 기준으로 정렬 함수로 전달
                self.sortAndSendRates(baseRates: self.rates)
                
            case .failure(_):
                // state => error
                self.state = .error(message: "데이터를 불러올 수 없습니다.") // 에러 발생시에 VC에 알림
            }
        }
    }
    
    
    // MARK: -- 데이터 필터링 메서드
    private func filterRates(searchText: String) {
        // 검색어 저장하기
        self.currentSearchText = searchText
        
        if searchText.isEmpty { // 검색창이 비었을때
            sortAndSendRates(baseRates: rates)
        } else {
            let filteredRates = rates.filter { item in
                
                // 통화 코드가 검색어를 포함하는지 검사
                let isCodeMatch = item.currencyCode.lowercased().contains(searchText.lowercased())
                
                // 국가명이 검색어를 포함하는지 검사
                let countryName = CountryDictionary.countryDictionary[item.currencyCode] ?? ""
                let isCountryMatch = countryName.contains(searchText)
                
                // 둘중에 하나라도 만족하면 true 반환
                return isCodeMatch || isCountryMatch
            }
            
            sortAndSendRates(baseRates: filteredRates)
        }
    }
    
    
    // MARK: -- 즐겨찾기 기준 정렬 메서드
    private func sortAndSendRates(baseRates: [SimpleRate]) {
        // 즐겨찾기 그룹
        let favoriteGroup = baseRates.filter { $0.isFavorite }
            .sorted { $0.currencyCode < $1.currencyCode }
        
        // !즐겨찾기 그룹
        let normalGroup = baseRates.filter { !$0.isFavorite }
            .sorted { $0.currencyCode < $1.currencyCode }
        
        let combinedGroup = favoriteGroup + normalGroup
        self.state = .success(rates: combinedGroup)
    }
    
    
    // MARK: -- 즐겨찾기 설정 메서드
    private func handleToggleFavorite(code: String) {
        
        // 원본 rates 배열 즐겨찾기 업데이트
        if let index = rates.firstIndex(where: { $0.currencyCode == code }) {
            rates[index].isFavorite.toggle()
        }
        
        // 이미 즐겨찾기 되어있는 경우
        if favoriteCodes.contains(code) {
            favoriteCodes.removeAll { $0 == code }
            
            // 코어데이터에서도 삭제하는 로직
            let fetchRequest = FavoriteCurrency.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "favoriteCode == %@", code)
            
            do {
                // fetch request 실행
                let result = try self.context.fetch(fetchRequest)
                // 결과 처리
                for data in result as [NSManagedObject] {
                    // 삭제
                    self.context.delete(data)
                }
            } catch {
                print("데이터 삭제 실패: \(error)")
            }
            
        // 즐겨찾기 안되어있으면 추가하기
        } else {
            favoriteCodes.append(code)
            
            // 코어데이터에도 추가하는 로직
            let newFavorite = FavoriteCurrency(context: context)
            newFavorite.favoriteCode = code
        }
        
        // 변경된 내용 기기에 최종 저장
        CoreDataManager.shared.saveContext()
        
        // 즐겨찾기 설정이 변경되었으므로 업데이트 (검색중일 수 있으므로 filterRates 실행함)
        filterRates(searchText: self.currentSearchText)
    }
    
    
    // MARK: -- 환율등락 비교 및 코어데이터 캐싱
    private func checkUpDownUpdateCache(code: String, newRate: Double, newTime: Int64) -> String {
        let context = CoreDataManager.shared.context
        
        // 코어데이터에서 옛날 데이터 찾아오기
        let fetchRequest = CachedRate.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "currencyCode == %@", code)
        
        do {
            let results = try context.fetch(fetchRequest)
            
            if let cachedData = results.first {
                let cachedTime = cachedData.lastUpdateTime
                let cachedRate = cachedData.rate
                
                // 시간 변경 (환율 갱신)
                if newTime != cachedTime {
                    var upDown = ""
                    if (newRate - cachedRate) >= 0.01 {
                        upDown = "📈"
                    } else if (cachedRate - newRate) >= -0.01 {
                        upDown = "📉"
                    }
                    
                    // 새로운 값으로 덮어씌움
                    cachedData.rate = newRate
                    cachedData.lastUpdateTime = newTime
                    cachedData.lastUpDown = upDown
                    
                    CoreDataManager.shared.saveContext()
                    return upDown
                }
                else {
                    // last 시간과 내 시간이 같을때 (이미 갱신 완)
                    return cachedData.lastUpDown ?? ""
                }
                
            } else {
                // 옛날 데이터가 없는 경우
                let newCache = CachedRate(context: context)
                newCache.currencyCode = code
                newCache.rate = newRate
                newCache.lastUpdateTime = newTime
                newCache.lastUpDown = ""
                
                CoreDataManager.shared.saveContext()
                return ""
            }
        } catch {
            print("에러 발생 \(error)")
            return ""
        }
    }
}

