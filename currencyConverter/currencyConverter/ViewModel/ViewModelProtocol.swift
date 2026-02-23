//
//  ViewModelProtocol.swift
//  currencyConverter
//
//  Created by t2025-m0143 on 2/23/26.
//

protocol ViewModelProtocol {
    associatedtype Action
    associatedtype State
    
    var update: ((Action) -> Void)? { get }
    var state: State { get }
}
