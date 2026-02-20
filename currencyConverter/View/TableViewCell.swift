//
//  TableViewCell.swift
//  currencyConverter
//
//  Created by 손영빈 on 2/12/26.
//

import UIKit
import SnapKit

protocol TableViewCellDelegate: AnyObject {
    func didTapStarButton(cell: TableViewCell)
}

class TableViewCell: UITableViewCell {
    
    weak var delegate: TableViewCellDelegate?
    
    static let id = "TableViewCell"
    
    let currencyLabel = UILabel()
    let countryLabel = UILabel()
    let labelStackView = UIStackView()
    let rateLabel = UILabel()
    let statusImage = UIImageView()
    let starButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setAttributes()
        setLayout()
        setAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TableViewCell {
    private func setAttributes() {
        
        self.backgroundColor = .backgroundColor
        
        currencyLabel.font = .systemFont(ofSize: 16, weight: .medium)
        currencyLabel.textColor = .textColor
        
        countryLabel.font = .systemFont(ofSize: 14)
        countryLabel.textColor = .secondaryTextColor
        
        labelStackView.axis = .vertical
        labelStackView.spacing = 4
        
        rateLabel.font = .systemFont(ofSize: 16)
        rateLabel.textColor = .textColor
        rateLabel.textAlignment = .right
        
        statusImage.tintColor = .button
        
        starButton.setImage(UIImage(systemName: "star"), for: .normal)
        starButton.tintColor = .favoriteColor
        
    }
    private func setLayout() {
        [labelStackView, rateLabel, statusImage, starButton].forEach { contentView.addSubview($0) }
        
        [currencyLabel, countryLabel].forEach { labelStackView.addArrangedSubview($0) }
        
        labelStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
        rateLabel.snp.makeConstraints {
            $0.trailing.equalTo(statusImage.snp.leading).offset(-16)
            $0.centerY.equalToSuperview()
            $0.leading.greaterThanOrEqualTo(labelStackView.snp.trailing).offset(16)
            $0.width.equalTo(120)
        }
        statusImage.snp.makeConstraints {
            $0.trailing.equalTo(starButton.snp.leading).offset(-16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(rateLabel.snp.height)
        }
        starButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(rateLabel.snp.height)
        }
    }
}

extension TableViewCell {
    func config(item: ExchangeRate, isSelected: Bool) {
        currencyLabel.text = item.code
        countryLabel.text = Mapper.getName(code: item.code)
        rateLabel.text = String(format: "%.4f", item.rate)
        
        switch item.status {
        case .up:
            statusImage.image = UIImage(systemName: "arrowtriangle.up.square.fill")
        case .down:
            statusImage.image = UIImage(systemName: "arrowtriangle.down.square.fill")
        case .stay:
            statusImage.image = nil
        }
        
        let image = isSelected ? "star.fill" : "star"
        starButton.setImage(UIImage(systemName: image), for: .normal)
    }
}

extension TableViewCell {
    private func setAction() {
        starButton.addTarget(self, action: #selector(starButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func starButtonTapped() {
        delegate?.didTapStarButton(cell: self)
    }
}
