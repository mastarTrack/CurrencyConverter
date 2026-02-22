//
//  ExchangeRateCellTableViewCell.swift
//  currencyConverter
//
//  Created by 김주희 on 2/17/26.
//

import UIKit
import SnapKit
import Then

class ExchangeRateTableViewCell: UITableViewCell {
    
    // 재사용 식별자 선언
    static let id = "ExchangeRateCell"
    
    
    // MARK: -- TableViewCell 내부 요소 UI 컴포넌트 선언
    // 통화 코드
    private let codeLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .bold)
        $0.textColor = .black
    }
    
    // 환율
    private let currencyLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.textColor = .black
        $0.textAlignment = .right
    }
    // 국가명
    private let countryLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .gray
    }
    // 통화 코드 + 국가명 스택뷰
    private let labelStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
    }
    
    
    // MARK: -- 초기화
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: -- addSubview, Snapkit
    private func setupUI() {
        
        [codeLabel, countryLabel].forEach { labelStackView.addArrangedSubview($0)}
        
        [labelStackView, currencyLabel].forEach { contentView.addSubview($0) }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        labelStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
        
        currencyLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.leading.greaterThanOrEqualTo(labelStackView.snp.trailing).offset(16)
            $0.width.equalTo(120)
        }
        
    }
    
    
    // MARK: -- text 데이터 대입 메서드
    func configure(code: String, rate: String, country: String) {
        codeLabel.text = code
        currencyLabel.text = rate
        countryLabel.text = country
    }
}
