//
//  ViewController.swift
//  currencyConverter
//
//  Created by t2025-m0143 on 2/10/26.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    let currencyView = CurrencyTableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configure()
    }
    
    func configure() {
        view.addSubview(currencyView)
        
        currencyView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
            
        }
    }
}

