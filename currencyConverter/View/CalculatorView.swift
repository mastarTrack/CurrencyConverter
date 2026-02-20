//
//  DetailView.swift
//  currencyConverter
//
//  Created by 손영빈 on 2/12/26.
//

import UIKit
import SnapKit

protocol CalculatorViewDelegate: AnyObject {
    func didTapConvertButton()
}

class CalculatorView: UIView {
    
    weak var delegate: CalculatorViewDelegate?
    
    private let currencyLabel = UILabel()
    private let countryLabel = UILabel()
    private let labelStackView = UIStackView()
    
    let amountTextField = UITextField()
    private let convertButton = UIButton()
    let resultLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAttributes()
        setLayout()
        setAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CalculatorView {
    private func setAttributes() {
        self.backgroundColor = .backgroundColor
        
        currencyLabel.font = .systemFont(ofSize: 24, weight: .bold)
        currencyLabel.textColor = .textColor
        
        countryLabel.font = .systemFont(ofSize: 16)
        countryLabel.textColor = .secondaryTextColor
        
        labelStackView.axis = .vertical
        labelStackView.spacing = 4
        labelStackView.alignment = .center
        
        amountTextField.borderStyle = .roundedRect
        amountTextField.keyboardType = .decimalPad
        amountTextField.textAlignment = .center
        amountTextField.placeholder = "금액을 입력하세요"
        amountTextField.textColor = .textColor
        amountTextField.backgroundColor = .backgroundColor
        
        convertButton.layer.cornerRadius = 8
        convertButton.backgroundColor = .buttonColor
        convertButton.setTitle("환율 계산", for: .normal)
        convertButton.setTitleColor(.textColor, for: .normal)
        convertButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        
        resultLabel.text = "계산 결과가 여기에 표시됩니다"
        resultLabel.font = .systemFont(ofSize: 20, weight: .medium)
        resultLabel.textAlignment = .center
        resultLabel.numberOfLines = 0
    }
    private func setLayout() {
        
        [labelStackView, amountTextField, convertButton, resultLabel].forEach { addSubview($0) }
        
        [currencyLabel, countryLabel].forEach { labelStackView.addArrangedSubview($0) }
        
        labelStackView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(32)
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

extension CalculatorView {
    func config(code: String) {
        self.currencyLabel.text = code
        self.countryLabel.text = Mapper.getName(code: code)
    }
}

extension CalculatorView {
    private func setAction() {
        convertButton.addTarget(self, action: #selector(convertButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func convertButtonTapped() {
        delegate?.didTapConvertButton()
    }
}
