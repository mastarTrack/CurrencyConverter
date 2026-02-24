//
//  ListCell.swift
//  currencyConverter
//
//  Created by Yeseul Jang on 2/23/26.
//

import Foundation
import UIKit
import SnapKit
import Then

final class ListCell: UICollectionViewCell {
    static let identifier = "ListCell"
    private let separatorView = UIView()
    private let favoritesButton = CustomButton()
    
    private let currencyLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .medium)
    }
    
    private let countryLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .gray
    }
    
    private lazy var labelStackView = UIStackView(arrangedSubviews: [
        currencyLabel,
        countryLabel
    ]).then {
        $0.axis = .vertical
        $0.spacing = 4
    }
    
    private let rateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
        $0.textAlignment = .right
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .clear
        contentView.addSubview(labelStackView)
        contentView.addSubview(rateLabel)
        contentView.addSubview(favoritesButton)
        
        configure()
        setupSeparator()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSeparator() {
        separatorView.backgroundColor = .separator
        contentView.addSubview(separatorView)

        let onePixel = 1.0 / UIScreen.main.scale
        let inset: CGFloat = 16

        separatorView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(inset)
            $0.trailing.equalToSuperview().inset(inset)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(onePixel)
        }
    }
    
    private func configure() {
        labelStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        favoritesButton.snp.makeConstraints {
            $0.height.width.equalTo(35)
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }

        rateLabel.snp.makeConstraints {
            $0.trailing.equalTo(favoritesButton.snp.leading).offset(-16)
            $0.centerY.equalToSuperview()
            $0.leading.greaterThanOrEqualTo(labelStackView.snp.trailing).offset(16)
        }
        
        labelStackView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        rateLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    func setData(item: Item) {
        currencyLabel.text = item.currency
        rateLabel.text = item.rate
        countryLabel.text = item.country
    }
}
