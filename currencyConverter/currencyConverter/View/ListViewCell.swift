//
//  ListViewCell.swift
//  currencyConverter
//
//  Created by t2025-m0143 on 2/13/26.
//
import UIKit
import SnapKit

final class ListViewCell: UICollectionViewListCell {
    let currencyNameLabel = UILabel()
    let currencyValueLabel = UILabel()
    
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
    func configure(name: String, value: String) {
        currencyNameLabel.text = name
        currencyValueLabel.text = value
    }
}

extension ListViewCell {
    private func setAttributes() {
        currencyNameLabel.font = .systemFont(ofSize: 16)
        currencyValueLabel.font = .systemFont(ofSize: 16)
    }
    
    private func setLayout() {
        contentView.addSubview(currencyNameLabel)
        contentView.addSubview(currencyValueLabel)
        
        currencyNameLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(10)
        }
        
        currencyValueLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(10)
            $0.trailing.equalToSuperview().inset(10)
        }
    }

}
