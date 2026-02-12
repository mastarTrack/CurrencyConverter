//
//  DetailViewController.swift
//  currencyConverter
//
//  Created by 손영빈 on 2/12/26.
//

import UIKit

class DetailViewController: UIViewController {
    
    var currency: String = ""
    var rate: Double = 0.0
    
    private let detailView = DetailView()
    
    override func loadView() {
        self.view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailView.config(code: currency)
        detailView.delegate = self
    }
}

extension DetailViewController {
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}

extension DetailViewController: DetailViewDelegate {
    func didTapConvertButton() {
        let inputText = detailView.amountTextField.text ?? ""
        if inputText.isEmpty {
            showAlert(message: "금액을 입력해주세요.")
            return
        }
        guard let amount = Double(inputText) else {
            showAlert(message: "금액을 숫자로 입력해주세요")
            return
        }
        let convertedValue = amount * rate
        let exchangeResult = String(format: "%.2f", convertedValue, currency)
        detailView.resultLabel.text = "$\(amount) : \(exchangeResult) \(currency)"
    }
}
