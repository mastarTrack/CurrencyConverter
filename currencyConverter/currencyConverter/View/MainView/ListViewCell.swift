//
//  ListViewCell.swift
//  currencyConverter
//
//  Created by t2025-m0143 on 2/13/26.
//
import UIKit
import SnapKit

final class ListViewCell: UICollectionViewListCell {
    private let currencyLabel = UILabel()
    private let countryLabel = UILabel()
    private let rateLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAttributes()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ListViewCell {
    func configure(code: String, country: String, rate: String) {
        currencyLabel.text = code
        countryLabel.text = country
        rateLabel.text = rate
    }
}

extension ListViewCell {
    private func setAttributes() {
        currencyLabel.font = .systemFont(ofSize: 16, weight: .medium)
        
        countryLabel.font = .systemFont(ofSize: 14)
        countryLabel.textColor = .gray
        
        rateLabel.font = .systemFont(ofSize: 16)
        rateLabel.textAlignment = .right
    }
    
    private func setLayout() {
        let labelStack = setLabelStackView()
        
        contentView.addSubview(labelStack)
        contentView.addSubview(rateLabel)
        
        contentView.snp.makeConstraints{
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        labelStack.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
        
        rateLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.leading.greaterThanOrEqualTo(labelStack.snp.trailing).offset(16)
            $0.width.equalTo(120)
        }
    }
    
    private func setLabelStackView() -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [currencyLabel, countryLabel])
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }

}
