//
//  CalculatorViewController.swift
//  currencyConverter
//
//  Created by 김주희 on 2/19/26.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    // MARK: -- View,VM 인스턴스 생성
    private let calculatorView = CalculatorView()
    private let viewModel: CalculatorViewModel
    
    // 초기화
    init(viewModel: CalculatorViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: -- 초기화
    override func loadView() {
        self.view = calculatorView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bindingData()
        viewModel.action?(.viewDidLoad)
    }
    
    
    // MARK: -- 메서드 정의
    // 데이터 바인딩
    private func bindingData() {
        
        // View의 Action -> VM으로 전달
        calculatorView.tappedConvertButton = { [weak self] in
            guard let self = self else { return }
            let inputText = self.calculatorView.amountText
            self.viewModel.action?(.calculateTapped(amount: inputText))
        }
        
        // VM의 state 변화 -> View 업데이트
        viewModel.stateChanged = { [weak self] state in
            DispatchQueue.main.async {
                self?.render(state) // state 메서드 호출
            }
        }
        
    }
    
    // state 상태에 따라 View 렌더링하기
    private func render(_ state: CalculatorViewModel.State) {
        switch state {
        case .none:
            break
            
        case .initialized(let code, let country):
            calculatorView.configure(code: code, country: country)
            
        case .calculateSuccess(let resultString):
            calculatorView.configureNum(result: resultString)
            
        case .error(let message):
            showErrorAlert(message: message)
        }
    }
}
