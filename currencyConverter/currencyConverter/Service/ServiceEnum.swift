//
//  Section.swift
//  currencyConverter
//
//  Created by t2025-m0143 on 2/19/26.
//

enum Section {
    case main
}

enum AlertType: String {
    case emptyData = "데이터를 불러올 수 없습니다."
    case emptyAmount = "금액을 입력해주세요."
    case invalidAmount = "올바른 숫자를 입력해주세요."
}
