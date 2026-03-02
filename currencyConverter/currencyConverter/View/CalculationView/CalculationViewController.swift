//
//  CalculationViewController.swift
//  currencyConverter
//
//  Created by t2025-m0143 on 2/20/26.
//

import UIKit

class CalculationViewController: UIViewController {
    private let calculationView = CalculationView()
    private(set) var viewModel: CalculationViewModel
    
    init(viewModel: CalculationViewModel) {
        self.viewModel = viewModel
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
        
        self.calculationView.configure(with: viewModel.rate)
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
        let resignTextField = UIAction { [weak self] _ in
            self?.calculationView.amountTextField.resignFirstResponder()
        }
        
        let calculation = UIAction { [weak self] _ in
            guard let self else { return }
            self.viewModel.checkAlert()
            self.viewModel.calculate()
        }
        
        calculationView.convertButton.addAction(resignTextField, for: .touchUpInside)
        calculationView.convertButton.addAction(calculation, for: .touchUpInside)
        
        // viewModel 동작 설정
        viewModel.alert = { [weak self] alertType in
            guard let alertType else { return }
            let alert = UIAlertController(status: alertType)
            self?.present(alert, animated: true)
        }
        
        viewModel.update = { [weak self] text in
            self?.calculationView.updateResultLabel(with: text)
        }
    }
    
    private func setTextFieldAction() {
        let save = UIAction { [weak self] _ in
            let text = self?.calculationView.amountTextField.text
            self?.viewModel.saveAmount(text ?? "")
        }
        
        calculationView.amountTextField.addAction(save, for: .editingChanged)
    }
}
