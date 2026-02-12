//
//  DetailView.swift
//  currencyConverter
//
//  Created by 손영빈 on 2/12/26.
//

import UIKit
import SnapKit

class DetailView: UIView {
    
    private let currencyLabel = UILabel()
    private let countryLabel = UILabel()
    private let labelStackView = UIStackView()
    
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

extension DetailView {
    private func setAttributes() {
        self.backgroundColor = .systemBackground
        
        currencyLabel.font = .systemFont(ofSize: 24, weight: .bold)
        
        countryLabel.font = .systemFont(ofSize: 16)
        countryLabel.textColor = .gray
        
        labelStackView.axis = .vertical
        labelStackView.spacing = 4
        labelStackView.alignment = .center
        
        amountTextField.borderStyle = .roundedRect
        amountTextField.keyboardType = .decimalPad
        amountTextField.textAlignment = .center
        amountTextField.placeholder = "금액을 입력하세요"
        
        convertButton.layer.cornerRadius = 8
        convertButton.backgroundColor = .systemBlue
        convertButton.setTitle("환율 계산", for: .normal)
        convertButton.setTitleColor(.white, for: .normal)
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
extension DetailView {
    func config(code: String) {
        self.currencyLabel.text = code
        self.countryLabel.text = Mapper.getName(code: code)
    }
}
