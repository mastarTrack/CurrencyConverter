//
//  CurrencyCell.swift
//  currencyConverter
//
//  Created by Hanjuheon on 2/20/26.
//

import UIKit
import SnapKit
import Then

class CurrencyCell: UICollectionViewCell {
    
    static let identifier = "CurrencyCell"
    
    //MARK: - Components
    private let isoCodeLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.text = "---"
    }
    
    private let countryNameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .gray
        $0.text = "------"
    }
    
    private let currencyLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
        $0.textAlignment = .right
        $0.text = "000"
    }
    
    //MARK: - INIT
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("CurrencyCell Init(coder:) Error")
    }
}

//MARK: - METHOD: Update UI
extension CurrencyCell {
    func updateUI(isoCode: String, countryName: String, rate: String){
        isoCodeLabel.text = isoCode
        countryNameLabel.text = countryName
        currencyLabel.text = rate
    }
}

//MARK: - METHOD: configure
extension CurrencyCell {
    func configureUI() {
        let mainView = UIView()
        let contryinfoStackView = UIStackView().then {
            $0.axis = .vertical
            $0.spacing =  4
        }
        
        contryinfoStackView.addArrangedSubview(isoCodeLabel)
        contryinfoStackView.addArrangedSubview(countryNameLabel)
        
        mainView.addSubview(contryinfoStackView)
        mainView.addSubview(currencyLabel)
        
        addSubview(mainView)
        
        mainView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        contryinfoStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
        
        currencyLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.leading.greaterThanOrEqualTo(contryinfoStackView.snp.trailing).offset(16)
            $0.width.equalTo(120)
        }
        
    }
}


@available(iOS 17.0, *)
#Preview {
    CurrencyCell()
}
