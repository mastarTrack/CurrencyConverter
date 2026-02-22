//
//  CalculatorViewModel.swift
//  currencyConverter
//
//  Created by 김주희 on 2/19/26.
//

import Foundation

class CalculatorViewModel: ViewModelProtocol{

    // MARK: -- Action, State 정의
    enum Action {
        case viewDidLoad    // 뷰 로드 -> 초기 데이터 요청하기
        case calculateTapped(amount: String?) // 계산 버튼 탭
    }
    
    enum State {
        case none
        case initialized(code: String, country: String)
        case calculateSuccess(result: String)
        case error(message: String)
    }
    
    var stateChanged: ((State) -> Void)?
    
    // state 상태 변경될때마다 바인딩 클로저 실행
    var state: State = .none {
        didSet {
            stateChanged?(state)
        }
    }
    
    lazy var action: ((Action) -> Void)? = { [weak self] action in
        guard let self = self else { return }
        
        switch action {
            
        case .viewDidLoad:
            self.state = .initialized(code: self.selectedCode!, country: self.selectedCountry!)
            
        case .calculateTapped(let amount):
            self.calculateInput(amount: amount) // 계산 메서드 호출
        }
    }

    
    // MARK: -- 초기화
    // 프로퍼티
    var selectedCode: String?
    var selectedCountry: String?
    var selectedRate: String?
    
    init(code: String, country: String, rate: String) {
        self.selectedCode = code
        self.selectedCountry = country
        self.selectedRate = rate
    }
    
    
    // MARK: -- 행동 처리 메서드
    func calculateInput(amount: String?) {
        // 빈칸 검사
        guard let text = amount, !text.isEmpty else {
            state = .error(message: "금액을 입력해주세요")
            return
        }
        
        // 숫자 변환 검사
        guard let Number = Double(text) else {
            state = .error(message: "올바른 숫자를 입력해주세요")
            return
        }
        
        let total = Number * Double(selectedRate!)!
        let formattedTotal = String(format: "%.2f", total)
        let resultString =  "$\(amount ?? "0") → \(formattedTotal) \(selectedCode ?? "0")"

        state = .calculateSuccess(result: resultString)
    }
}
