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
        
        currencyViewUpdate()
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
    
    private func currencyViewUpdate() {
        currencyViewModel.upDate = { [weak self] items in
            guard let self else { return }
            self.currencyView.update(newItems: items)
        }
    }
    
    private func showErrorAlert() {
        let alert = UIAlertController(
            title: "오류",
            message: "데이터를 불러올 수 없습니다",
            preferredStyle: .alert
        )

        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)

        present(alert, animated: true)
    }
    
}

