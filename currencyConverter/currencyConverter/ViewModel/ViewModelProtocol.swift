//
//  ViewModelProtocol.swift
//  currencyConverter
//
//  Created by t2025-m0143 on 2/23/26.
//

protocol ViewModelProtocol {
    associatedtype Update
    associatedtype ObservedData
    
    var update: ((Update) -> Void)? { get }
    var observedData: ObservedData { get }
}
