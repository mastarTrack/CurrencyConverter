//
//  ViewModelProtocol.swift
//  currencyConverter
//
//  Created by 김주희 on 2/20/26.
//


protocol ViewModelProtocol {
    associatedtype Action
    associatedtype State
    
    var action: ((Action) -> Void)? { get } // View -> VM
    var state: State { get } // VM의 상태
}
