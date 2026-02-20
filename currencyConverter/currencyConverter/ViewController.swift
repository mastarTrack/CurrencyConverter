//
//  ViewController.swift
//  currencyConverter
//
//  Created by t2025-m0143 on 2/10/26.
//

import UIKit
import SnapKit

final class ViewController: UIViewController {
    private let currencyView = CurrencyTableView()
    private let currencyViewModel = CurrencyViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        bindViewModel()
        configure()
        
        currencyViewModel.fetchCurrencyData()
    }
    
    private func configure() {
        view.addSubview(currencyView)
        
        currencyView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
            
        }
    }
    
    private func bindViewModel() {
        currencyViewModel.upDate = { [weak self] items in
            guard let self else { return }
            self.currencyView.update(newItems: items)
        }
        
        currencyViewModel.onError = { [weak self] message in
            self?.showErrorAlert(message: message)
        }
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "오류",
            message: message,
            preferredStyle: .alert
        )

        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
}

