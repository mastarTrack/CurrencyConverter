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
        $0.font = .systemFont(ofSize: 16, weight: .regular)
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
    
    // 즐겨찾기 버튼 구현
    private let favoriteButton = UIButton().then {
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)
        // SF symbol
        let image = UIImage(systemName: "star", withConfiguration: config)
        $0.setImage(image, for: .normal)
        $0.tintColor = .systemYellow
    }
    
    
    // MARK: -- View 이벤트 전달 클로저
    // favoriteButton 클로저
    var tappedfavoriteButton: (() -> Void)?
    
    
    // MARK: -- 초기화
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: -- addSubview, Snapkit
    private func setupUI() {
        
        [codeLabel, countryLabel].forEach { labelStackView.addArrangedSubview($0)}
        
        [labelStackView, currencyLabel, favoriteButton].forEach { contentView.addSubview($0) }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        labelStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
        
        currencyLabel.snp.makeConstraints {
            $0.trailing.equalTo(favoriteButton.snp.leading).offset(-10)
            $0.centerY.equalToSuperview()
            $0.leading.greaterThanOrEqualTo(labelStackView.snp.trailing).offset(16)
            $0.width.equalTo(120)
        }
        
        favoriteButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
    }
    
    
    // MARK: -- Action
    private func setupAction() {
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }

    
    // MARK: -- @objc 메서드
    @objc
    private func favoriteButtonTapped() {
        tappedfavoriteButton?() // 클로저 전달
    }

    
    // MARK: -- text 데이터 대입 메서드
    func configure(code: String, rate: String, country: String, isFavorite: Bool) {
        codeLabel.text = code
        currencyLabel.text = rate
        countryLabel.text = country
        
        let imageName = isFavorite ? "star.fill" : "star"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
}


#Preview {
    let dummyMainViewModel = ExchangeRateViewModel()
    return ExchangeRateViewController(viewModel: dummyMainViewModel)
}
