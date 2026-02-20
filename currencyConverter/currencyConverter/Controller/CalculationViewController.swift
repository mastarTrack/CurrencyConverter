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
        calculationView.configure(with: data)
        self.navigationItem.title = "환율 계산기"
    }
}
