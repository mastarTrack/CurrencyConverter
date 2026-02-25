//
//  BaseViewModelProtocol.swift
//  currencyConverter
//
//  Created by Hanjuheon on 2/23/26.
//

/// 환율정보 및 계산기 기초 ViewModel Protocol
protocol BaseViewModelProtocol {
    
    //MARK: - Properties
    var datas: [CurrencyData] { get }
    
    //MARK: - Closures
    var updateCurrencyClosure: ((String?)->Void)? { set get }
    var lastPageClosure: ((CurrencyData)->Void)? { set get }
    
    //MARK: - METHOD
    func fatchModelToSearch(searchText: String)
    func updateDataToFavorites(isoCode: String, isFavorite: Bool)
}
