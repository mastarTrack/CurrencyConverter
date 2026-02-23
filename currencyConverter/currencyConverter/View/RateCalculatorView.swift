//
//  RateCalculatorView.swift
//  currencyConverter
//
//  Created by Yeseul Jang on 2/23/26.
//

import Foundation
import UIKit
import SnapKit
import Then

class RateCalculatorView: UIView {
    
    private let currencyLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 24, weight: .bold)
    }
    
    private let countryLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .gray
    }
    
    private lazy var labelStackView = UIStackView(
        arrangedSubviews: [currencyLabel, countryLabel]
    ).then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .center
    }
    
    private let amountTextField = UITextField().then {
        $0.placeholder = "금액을 입력하세요"
        $0.borderStyle = .roundedRect
        $0.keyboardType = .decimalPad
        $0.textAlignment = .center
    }
    
    private let convertButton = UIButton(type: .system).then {
        $0.setTitle("환율계산", for: .normal)
        $0.backgroundColor = .systemBlue
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    private let resultLabel = UILabel().then {
        $0.text = "계산 결과가 여기에 표시됩니다."
        $0.font = .systemFont(ofSize: 20, weight: .medium)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    var amountText: String { amountTextField.text ?? "" }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(labelStackView)
        addSubview(amountTextField)
        addSubview(convertButton)
        addSubview(resultLabel)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(item: Item) {
        countryLabel.text = item.country
        currencyLabel.text = item.currency
    }
    
    func setResultLabel(_ text: String) {
        resultLabel.text = text
    }
    
    func tapConvertButton(_ handler: @escaping () -> Void) {
        convertButton.addAction(UIAction { _ in
            handler()
        }, for: .touchUpInside)
    }
    
    private func setupConstraints() {
        labelStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(32)
            $0.centerX.equalToSuperview()
        }
        
        amountTextField.snp.makeConstraints {
            $0.top.equalTo(labelStackView.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }
        
        convertButton.snp.makeConstraints {
            $0.top.equalTo(amountTextField.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }
        
        resultLabel.snp.makeConstraints {
            $0.top.equalTo(convertButton.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    }
}
