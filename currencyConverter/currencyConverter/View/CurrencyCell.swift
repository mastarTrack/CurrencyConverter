//
//  CurrencyCell.swift
//  currencyConverter
//
//  Created by Hanjuheon on 2/20/26.
//

import UIKit
import SnapKit
import Then

/// 국가 환율 정보 및 즐겨찾기 표기 Cell
class CurrencyCell: UICollectionViewCell {
    
    static let identifier = "CurrencyCell"
    
    //MARK: - Components
    /// IsoCode 표기 레이블
    private let isoCodeLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.textColor = UIColor(named: CommonUtils.CustomColor.textColor.rawValue)
        $0.text = "---"
    }
    /// 국가이름 표기 레이블
    private let countryNameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = UIColor(named: CommonUtils.CustomColor.secondaryTextColor.rawValue)
        $0.text = "------"
    }
    /// 국가 환율 표기 레이블
    private let currencyLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
        $0.textAlignment = .right
        $0.textColor = UIColor(named: CommonUtils.CustomColor.textColor.rawValue)
        $0.text = "000"
    }
    /// 즐겨찾기 버튼
    private let favoritesButton = UIButton().then {
        let config = UIImage.SymbolConfiguration(pointSize: 30)

        $0.setImage(UIImage(systemName: "star", withConfiguration: config), for: .normal)
        $0.setImage(UIImage(systemName: "star.fill", withConfiguration: config), for: .selected)

        $0.tintColor = UIColor(named: CommonUtils.CustomColor.favoriteColor.rawValue)
        $0.isSelected = false
    }
    
    //MARK: - Closures
    /// 즐겨찾기 버튼 액션용 클로져
    var favoritesTouchClosure: ((Bool)->Void)?
    
    //MARK: - INIT
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(named: CommonUtils.CustomColor.cellBackground.rawValue)
        contentView.layer.borderColor = UIColor(named: CommonUtils.CustomColor.cellBorderLine.rawValue)?
            .resolvedColor(with: traitCollection)
            .cgColor
        contentView.layer.borderWidth = 0.3
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("CurrencyCell Init(coder:) Error")
    }
}

//MARK: - METHOD: Update UI
extension CurrencyCell {
    /// UI Components 표기 값 갱신 메소드
    func updateUI(isoCode: String, countryName: String, rate: String, isFavorite: Bool) {
        isoCodeLabel.text = isoCode
        countryNameLabel.text = countryName
        currencyLabel.text = rate
        favoritesButton.isSelected = isFavorite
    }
    /// 즐겨찾기 버튼 갱신 메소드
    func updateFavoritesUI() {
        favoritesButton.isSelected.toggle()
        favoritesTouchClosure?(favoritesButton.isSelected)
    }
}

//MARK: - METHOD: configure
extension CurrencyCell {
    /// 초기 UI 설정 메소드
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
        mainView.addSubview(favoritesButton)
        
        favoritesButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            self.updateFavoritesUI()
        }, for: .touchUpInside)
        
        contentView.addSubview(mainView)
        
        mainView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        contryinfoStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
        
        currencyLabel.snp.makeConstraints {
            $0.leading.greaterThanOrEqualTo(contryinfoStackView.snp.trailing).offset(16)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(120)
        }
        
        favoritesButton.snp.makeConstraints {
            $0.leading.equalTo(currencyLabel.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()

        }
        
    }
}


@available(iOS 17.0, *)
#Preview {
    CurrencyCell()
}
