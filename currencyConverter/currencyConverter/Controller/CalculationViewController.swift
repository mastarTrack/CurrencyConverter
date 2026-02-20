//
//  CalculationViewController.swift
//  currencyConverter
//
//  Created by t2025-m0143 on 2/20/26.
//

import UIKit

class CalculationViewController: UIViewController {
    private let data: Rate
    private let calculationView = CalculationView()
    private var stringAmount: String?
    
    init(data: Rate) {
        self.data = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = calculationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "환율 계산기"
        
        calculationView.configure(with: data)
        setActions()
    }
    
}

//MARK: set Actions
extension CalculationViewController {
    private func setActions() {
        setButtonAction()
        setTextFieldAction()
    }
    
    private func setButtonAction() {
        let resignTextField = UIAction { _ in
            self.calculationView.resignTextField()
        }
        
        let calculation = UIAction { _ in
            // 입력이 빈칸일 경우
            guard let string = self.stringAmount, !string.isEmpty else {
                let alert = UIAlertController(status: .emptyAmount)
                self.present(alert, animated: true)
                return
            }
            
            // 입력이 숫자가 아닐 경우
            guard let amount = Double(string) else {
                let alert = UIAlertController(status: .invalidAmount)
                self.present(alert, animated: true)
                return
            }
            
            self.calculationView.updateResultLabel(with: "\(amount)")
        }
        
        calculationView.setButtonAction(resignTextField)
        calculationView.setButtonAction(calculation)
    }
    
    private func setTextFieldAction() {
        let save = UIAction { [weak self] _ in
            let text = self?.calculationView.passAmountText()
            self?.stringAmount = text
        }
        
        calculationView.setTextFieldAction(save)
    }
}
