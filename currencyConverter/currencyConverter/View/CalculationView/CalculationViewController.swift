//
//  CalculationViewController.swift
//  currencyConverter
//
//  Created by t2025-m0143 on 2/20/26.
//

import UIKit

class CalculationViewController: UIViewController {
    private let calculationView = CalculationView()
    private let viewModel: CalculationViewModel
    
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
        
        configure()
        setActions()
    }
    
}
//MARK: Configure
extension CalculationViewController {
    private func configure() {
        let data = viewModel.fetchData()
        calculationView.configure(with: data)
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
            self?.calculationView.resignTextField()
        }
        
        let calculation = UIAction { [weak self] _ in
            guard let self else { return }
            self.viewModel.checkAlert()
            self.viewModel.calculate()
        }
        
        calculationView.setButtonAction(resignTextField)
        calculationView.setButtonAction(calculation)
        
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
            let text = self?.calculationView.passAmountText()
            self?.viewModel.saveAmount(text ?? "")
        }
        
        calculationView.setTextFieldAction(save)
    }
}
