//
//  CalculatorView.swift
//  currencyConverter
//
//  Created by 김주희 on 2/18/26.
//

import UIKit
import SnapKit
import Then

class CalculatorView: UIView {
    
    // MARK: -- 계산기 View UI 컴포넌트 선언
    // 통화 + 국가 스택뷰
    private let labelStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .center
    }
    
    // 통화 코드 레이블
    private let codeLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 24, weight: .bold)
        $0.textAlignment = .center
        $0.textColor = UIColor(named: "TextColor")
    }
    
    // 국가 이름 레이블
    private let countryLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = UIColor(named: "SecondaryTextColor")
    }
    
    // 입력 필드
    private let amountTextField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.keyboardType = .decimalPad
        $0.placeholder = "달러(USD)를 입력하세요"
        $0.textAlignment = .center
        $0.backgroundColor = .systemGray6
    }
    
    // 변환 버튼
    private let convertButton = UIButton().then {
        $0.setTitle("환율 계산", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .systemBlue
        $0.layer.cornerRadius = 8
        $0.addTarget(self, action: #selector(convertButtonTapped), for: .touchUpInside)
    }
    
    // 결과 표시
     private let resultLabel = UILabel().then {
        $0.text = "계산 결과가 여기에 표시됩니다"
        $0.font = .systemFont(ofSize: 20, weight: .medium)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.textColor = UIColor(named: "TextColor")

    }
    
    
    // MARK: -- View 이벤트 전달
    // convertButton 클로저
    var tappedConvertButton: (() -> Void)?
    
    // textField 값 전달 프로퍼티
    var amountText: String? {
        return amountTextField.text
    }
    
    
    // MARK: -- 초기화
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(named: "BackgroundColor")
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: -- addSubView, SnapKit
    private func setupLayout() {
        
        [codeLabel, countryLabel].forEach { labelStackView.addArrangedSubview($0) }
        
        [labelStackView, amountTextField, convertButton, resultLabel].forEach {
            self.addSubview($0)
        }
        
        labelStackView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(32)
            $0.centerX.equalToSuperview()
        }
        
        amountTextField.snp.makeConstraints {
            $0.top.equalTo(labelStackView.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }
        
        convertButton.snp.makeConstraints {
            $0.top.equalTo(amountTextField.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }
        
        resultLabel.snp.makeConstraints {
            $0.top.equalTo(convertButton.snp.bottom).offset(32)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
    }
    
    
    // MARK: -- @objc 메서드
    @objc
    private func convertButtonTapped() {
        tappedConvertButton?() // 클로저 전달
    }

    
    // MARK: -- text 데이터 대입 메서드
    func configure(code: String, country: String) {
        codeLabel.text = code
        countryLabel.text = country
    }
    
    func configureNum(result: String){
        resultLabel.text = result
    }
}


#Preview {
    let dummyCalculatorViewModel = CalculatorViewModel(code: "234", country: "234", rate: "4324")
    CalculatorViewController(viewModel: dummyCalculatorViewModel)
}
