//
//  Rate.swift
//  currencyConverter
//
//  Created by t2025-m0143 on 2/19/26.
//

struct Rate: Hashable {
    let name: String
    let value: Double
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name) // 통화 이름을 hash값으로 사용
    }
}
