//
//  WorldCurrencyViewmodel.swift
//  currencyConverter
//
//  Created by Hanjuheon on 2/20/26.
//

import Alamofire
import Foundation
import CoreData

/// 전세계 달러 대비 환율 정보 처리용 ViewModel
class WorldCurrencyViewmodel: BaseViewModelProtocol {

    //MARK: - Properties
    /// 전세계 환율 모델 메니저
    private var manager = WorldCurrencyManager()
    /// API 서비스 크래스
    private var apiService = APIService()
    /// 뷰에 전송용 환율 데이터
    private(set) var datas: [CurrencyData] = []
    /// 검색값 저장 텍스트
    private var searchText = ""
    /// CoreData 컨테이너
    var coreData: NSPersistentContainer!
    /// 지정 국가 환율 데이터
    var selectData: CurrencyData?
    
    //MARK: - Closures
    /// 업데이트 요청 클로저
    var updateCurrencyClosure: ((String?)->Void)?

    //MARK: - Init
    init() {
        fatchWorldCurrency()
    }
}


//MARK: - METHOD: Calculate
extension WorldCurrencyViewmodel {
    /// 입력된 통화에 선택된 통화를 계산하는 메소드
    func calculateSelectDataCurrency(amount: Double) -> Double? {
        guard let selectData = selectData else { return nil }
        return amount*selectData.rate
    }
}

//MARK: - METHOD: DataUpdate
extension WorldCurrencyViewmodel {
    
    /// 입력된 값이 포함된 데이터 조회 메소드
    func fatchModelToSearch(searchText: String) {
        self.searchText = searchText
        datas = self.searchText.isEmpty ? manager.worldCurrencyDatas : manager.worldCurrencyDatas.filter{
            $0.isoCode.lowercased().contains(self.searchText.lowercased()) || $0.countryName.contains(self.searchText)
        }
    }
    
    /// 즐겨찾기 체크 업데이트 메소드
    func updateDataToFavorites(isoCode: String, isFavorite: Bool){
        manager.updateDataToFavorites(isoCode: isoCode, isFavorite: isFavorite)
        
        /// CoreData 즐겨찾기 데이터 관리
        if isFavorite {
            CurrencyCoreDataManager.createFavoriteData(isoCode: isoCode, isFavorite: isFavorite)
        } else {
            CurrencyCoreDataManager.deleteFavoriteData(isoCode: isoCode)
        }
        
        fatchModelToSearch(searchText: searchText)
        datas = manager.sortData(datas: datas)
    }
}

//MARK: - METHOD: Datafatch
extension WorldCurrencyViewmodel {
    /// 달러기준 전세계 환율 조회 API 호출 메소드
    func fatchWorldCurrency(){
        guard let url = URLComponents(string: apiService.baseURL)?.url else {
            fatalError("fatchWorldCurrency url Error")
        }
        apiService.fatchWorldCurrency(url: url) { [weak self] (result: Result<WorldCurrencyModel, AFError>) in
            guard let self else { return }
            switch result {
            case .success(let result):
                manager.updateData(model: result)
                
                let favoriteDatas = CurrencyCoreDataManager.ReadFavoriteData()
                manager.updateDataToCoreDataFavorites(datas: favoriteDatas)
                
                datas = manager.worldCurrencyDatas
                DispatchQueue.main.async {
                    self.updateCurrencyClosure?(nil)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.updateCurrencyClosure?(error.localizedDescription)
                }
            }
        }
    }
}

