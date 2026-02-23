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
    var selectData: CurrencyData?  {get set}
    
    //MARK: - Closures
    var updateCurrencyClosure: ((String?)->Void)? { set get }
    
    //MARK: - METHOD
    func calculateSelectDataCurrency(amount: Double) -> Double?
    func fatchModelToSearch(searchText: String)
    func updateDataToFavorites(isoCode: String, isFavorite: Bool)
}
