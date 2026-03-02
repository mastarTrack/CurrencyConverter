//
//  CalculationViewModel.swift
//  currencyConverter
//
//  Created by t2025-m0143 on 2/23/26.
//
import Foundation

class CalculationViewModel: ViewModelProtocol {
    var initialize: ((Rate) -> Void)?
    var update: ((String) -> Void)?
    var alert: ((AlertType?) -> Void)?
    
    private(set) var rate: Rate // 현재 환율 데이터
    private var amount: Double? // textField 입력 금액
    private var amountIsEmpty: Bool = false // textField 공백 여부
    private var alertType: AlertType?
    
    private(set) var observedData: Double? { // 결과 금액
        didSet {
            if let alertType { // 오류 존재 시
                alert?(alertType)
            } else { // 오류 없을 시
                let string = self.resultToString(observedData)
                update?(string)
            }
        }
    }
    
    init(data: Rate) {
        self.rate = data
    }
    
    // 데이터 전달
    func fetchData() -> Rate {
        return rate
    }
    
    // textField 입력값 저장
    func saveAmount(_ string: String) {
        amountIsEmpty = string.isEmpty ? true : false
        amount = Double(string)
    }
    
    // alert 타입 할당
    func checkAlert() {
        if amountIsEmpty { // 입력이 빈칸일 경우
            alertType = .emptyAmount
        } else if amount == nil { // 입력이 숫자가 아닐 경우
            alertType = .invalidAmount
        } else {
            alertType = nil
        }
    }
}

//MARK: logic
extension CalculationViewModel {
    func calculate() {
        observedData = (amount ?? 0) * rate.value
    }
    
    private func resultToString(_ result: Double?) -> String {
        let stringAmount = String(format: "%.2f", (amount ?? 0))
        let stringResult = String(format: "%.2f", (observedData ?? 0))
        
        return "$\(stringAmount) → \(stringResult) \(rate.currencyCode)"
    }
}
