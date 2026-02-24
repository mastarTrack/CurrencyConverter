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
    private(set) var starButton = UIButton()
    private var starButtonSelected: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAttributes()
        setLayout()
        setButtonAction()
        
        accessories = [.customView(configuration: .init(customView: starButton, placement: .trailing(displayed: .always)))]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ListViewCell {
    func configure(_ rate: Rate, value: String, action: @escaping (() -> Void)) {
        currencyLabel.text = rate.currencyCode
        countryLabel.text = rate.country
        rateLabel.text = value
        starButton.isSelected = rate.bookMarked
        starButtonSelected = action
    }
    
    func setButtonAction() {
        let select = UIAction { [weak self] _ in
            self?.starButton.isSelected.toggle()
            self?.starButtonSelected?()
        }
        
        starButton.addAction(select, for: .touchUpInside)
    }
}

extension ListViewCell {
    private func setAttributes() {
        currencyLabel.font = .systemFont(ofSize: 16, weight: .medium)
        currencyLabel.textColor = .text
        
        countryLabel.font = .systemFont(ofSize: 14)
        countryLabel.textColor = .secondaryText
        
        rateLabel.font = .systemFont(ofSize: 16)
        rateLabel.textAlignment = .right
        rateLabel.textColor = .text
        
        starButton.setImage(UIImage(systemName: "star"), for: .normal)
        starButton.setImage(UIImage(systemName: "star.fill"), for: .selected)
        starButton.tintColor = .favorite
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
            $0.trailing.equalToSuperview().inset(32)
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
