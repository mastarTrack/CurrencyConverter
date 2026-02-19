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
    let starButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setAttributes()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TableViewCell {
    private func setAttributes() {
        currencyLabel.font = .systemFont(ofSize: 16, weight: .medium)
        
        countryLabel.font = .systemFont(ofSize: 14)
        countryLabel.textColor = .gray
        
        labelStackView.axis = .vertical
        labelStackView.spacing = 4
        
        rateLabel.font = .systemFont(ofSize: 16)
        rateLabel.textAlignment = .right
        
        starButton.setImage(UIImage(systemName: "star"), for: .normal)
        starButton.tintColor = .yellow
        
    }
    private func setLayout() {
        [labelStackView, rateLabel, starButton].forEach { contentView.addSubview($0) }
        
        [currencyLabel, countryLabel].forEach { labelStackView.addArrangedSubview($0) }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        labelStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
        rateLabel.snp.makeConstraints {
            $0.trailing.equalTo(starButton.snp.leading).offset(-16)
            $0.centerY.equalToSuperview()
            $0.leading.greaterThanOrEqualTo(labelStackView.snp.trailing).offset(16)
            $0.width.equalTo(120)
        }
        starButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(rateLabel.snp.height)
        }
    }
}

extension TableViewCell {
    func config(code: String, rate: Double) {
        currencyLabel.text = code
        countryLabel.text = Mapper.getName(code: code)
        rateLabel.text = String(format: "%.4f", rate)
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
