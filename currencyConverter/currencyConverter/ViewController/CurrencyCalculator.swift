//
//  CurrencyCalculator.swift
//  currencyConverter
//
//  Created by Hanjuheon on 2/23/26.
//

import UIKit
import SnapKit
import Then

class CurrencyCalculator: UIViewController {
    
    //MARK: - ViewModel
    let currencyData: CurrencyData
    
    //MARK: - Components
    let amountTextField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.keyboardType = .decimalPad
        $0.textAlignment = .center
        $0.placeholder = "금액을 입력하세요"
    }
    
    let convertButton = UIButton().then {
        $0.backgroundColor = .systemBlue
        $0.titleLabel?.textColor = .white
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        $0.layer.cornerRadius = 8
        $0.setTitle("환율 계산", for: .normal)
    }
    
    let resultLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .medium)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    //MARK: - Init
    init(currencyData: CurrencyData) {
        self.currencyData = currencyData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.backButtonDisplayMode = .default
        self.title = "환율 계산기"
        ConfigureUI()
    }
}


//MARK: - METHOD: Configure UI
extension CurrencyCalculator {
    func ConfigureUI() {
        let infoStackView = UIStackView().then {
            $0.axis = .vertical
            $0.distribution = .fill
            $0.alignment = .center
            $0.spacing = 4
        }
        
        let isoLabel = UILabel().then {
            $0.font = .systemFont(ofSize: 24, weight: .bold)
            $0.text = currencyData.isoCode
        }
        
        let countryLabel = UILabel().then {
            $0.font = .systemFont(ofSize: 16)
            $0.textColor = .gray
            $0.text = currencyData.countryName
        }
        
        let basicCurrencyLabel = UILabel().then {
            $0.font = .systemFont(ofSize: 16)
            $0.textColor = .gray
            $0.text = "USD $1 = \(CommonUtils.formatCurrency(rate: currencyData.rate, isoCode: currencyData.isoCode))"
        }
        
        infoStackView.addArrangedSubview(isoLabel)
        infoStackView.addArrangedSubview(countryLabel)
        infoStackView.addArrangedSubview(basicCurrencyLabel)
        
        view.addSubview(infoStackView)
        view.addSubview(amountTextField)
        view.addSubview(convertButton)
        view.addSubview(resultLabel)
        
        infoStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            $0.centerX.equalToSuperview()
        }
        
        amountTextField.snp.makeConstraints {
            $0.top.equalTo(infoStackView.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }
        
        convertButton.snp.makeConstraints {
            $0.top.equalTo(amountTextField.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }
        
        resultLabel.snp.makeConstraints {
            $0.top.equalTo(convertButton.snp.bottom).offset(32)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().inset(24)
        }
        
    }
}


@available(iOS 17.0, *)
#Preview {
    let currencyData = CurrencyData(isoCode: "KOR", rate: 1500, countryName: "대한민국")
    CurrencyCalculator(currencyData: currencyData)
}
