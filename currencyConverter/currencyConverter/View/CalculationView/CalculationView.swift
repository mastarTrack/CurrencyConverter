//
//  CalculationView.swift
//  currencyConverter
//
//  Created by t2025-m0143 on 2/20/26.
//

import UIKit
import SnapKit

class CalculationView: UIView {
    private let currencyLabel = UILabel()
    private let countryLabel = UILabel()
    private let amountTextField = UITextField()
    private let convertButton = UIButton()
    private let resultLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAttributes()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CalculationView {
    func configure(with data: Rate) {
        currencyLabel.text = data.currencyCode
        countryLabel.text = data.country
    }
}

extension CalculationView {
    private func setAttributes() {
        backgroundColor = .white
        
        currencyLabel.font = .systemFont(ofSize: 24, weight: .bold)
        
        countryLabel.font = .systemFont(ofSize: 16)
        countryLabel.textColor = .gray
        
        amountTextField.borderStyle = .roundedRect
        amountTextField.keyboardType = .decimalPad
        amountTextField.textAlignment = .center
        amountTextField.placeholder = "금액을 입력하세요"
        
        convertButton.backgroundColor = .systemBlue
        convertButton.tintColor = .white
        convertButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        convertButton.layer.cornerRadius = 8
        convertButton.setTitle("환율 계산", for: .normal)
        
        resultLabel.font = .systemFont(ofSize: 20, weight: .medium)
        resultLabel.textAlignment = .center
        resultLabel.numberOfLines = 0
        resultLabel.text = "계산 결과가 여기에 표시됩니다"
    }
    
    private func setLayout() {
        let labelStack = makeLabelStackView()
        
        addSubview(labelStack)
        addSubview(amountTextField)
        addSubview(convertButton)
        addSubview(resultLabel)
        
        labelStack.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(32)
            $0.centerX.equalToSuperview()
        }
        
        amountTextField.snp.makeConstraints {
            $0.top.equalTo(labelStack.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }
        
        convertButton.snp.makeConstraints {
            $0.top.equalTo(amountTextField.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }
        
        resultLabel.snp.makeConstraints {
            $0.top.equalTo(convertButton.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
    }
    
    private func makeLabelStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [currencyLabel, countryLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .center
        return stackView
    }
}
