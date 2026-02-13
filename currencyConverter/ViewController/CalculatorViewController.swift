//
//  DetailViewController.swift
//  currencyConverter
//
//  Created by 손영빈 on 2/12/26.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    private let calculatorView = CalculatorView()
    private let viewModel: CalculatorViewModel
    
    init(viewModel: CalculatorViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = calculatorView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        calculatorView.config(code: viewModel.item.code)
        calculatorView.delegate = self
    }
}

extension CalculatorViewController {
    private func updateUI() {
        viewModel.updateData = { [weak self] result in
            self?.calculatorView.resultLabel.text = result
        }
        viewModel.showError = { [weak self] error in
            self?.showAlert(message: error)
        }
    }
}

extension CalculatorViewController {
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}

extension CalculatorViewController: CalculatorViewDelegate {
    func didTapConvertButton() {
        viewModel.inputText(inputText: calculatorView.amountTextField.text)
    }
}
