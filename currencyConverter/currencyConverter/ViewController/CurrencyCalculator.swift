//
//  CurrencyCalculator.swift
//  currencyConverter
//
//  Created by Hanjuheon on 2/23/26.
//

import UIKit
import SnapKit
import Then

class CurrencyCalculator: BaseViewController {
        
    //MARK: - ViewModel
    let vm : WorldCurrencyViewmodel
    
    //MARK: - Components
    /// 달러 입력 텍스트 필드
    let amountTextField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.keyboardType = .decimalPad
        $0.textAlignment = .center
        $0.placeholder = "USD(달러) 금액을 입력하세요"
    }
    
    /// 전환 버튼
    let convertButton = UIButton().then {
        $0.backgroundColor = .systemBlue
        $0.titleLabel?.textColor = .white
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        $0.layer.cornerRadius = 8
        $0.setTitle("환율 계산", for: .normal)
        $0.backgroundColor = UIColor(named: CommonUtils.CustomColor.buttonColor.rawValue)
    }
    
    /// 결과값 도출 레이블
    let resultLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .medium)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.textColor = UIColor(named: CommonUtils.CustomColor.textColor.rawValue)
    }
    
    //MARK: - Init
    init(viewModel: WorldCurrencyViewmodel) {
        self.vm = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: CommonUtils.CustomColor.background.rawValue)
        navigationItem.backButtonDisplayMode = .default
        self.title = "환율 계산기"
        ConfigureUI()
    }
}

//MARK: - METHOD: TextField Delegate
extension CurrencyCalculator: UITextFieldDelegate {
    /// 텍스트 필드 엔터키 처리 메소드
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        amountTextField.resignFirstResponder()
        CalculatorCurrency()
        return true
    }
}

//MARK: - METHOD: Currency Calculate
extension CurrencyCalculator {
    /// 환율계산 및 표기 메소드
    func CalculatorCurrency() {
        guard let text = amountTextField.text, !text.isEmpty else {
            showWarning(message: "값을 입력해주세요.")
            return
        }
        guard let amount = Double(text) else {
            showWarning(message: "숫자만 입력해주세요.")
            return
        }
        
        resultLabel.text = CommonUtils.formatCurrency(
            rate: vm.calculateSelectDataCurrency(amount: amount) ?? 0,
            isoCode: vm.selectData?.isoCode ?? "", digit: 2)
    }
}


//MARK: - METHOD: Configure UI
extension CurrencyCalculator {
    /// 초기 UI 설정 메소드
    func ConfigureUI() {
        let infoStackView = UIStackView().then {
            $0.axis = .vertical
            $0.distribution = .fill
            $0.alignment = .center
            $0.spacing = 4
        }
        
        let isoLabel = UILabel().then {
            $0.font = .systemFont(ofSize: 24, weight: .bold)
            $0.textColor = UIColor(named: CommonUtils.CustomColor.textColor.rawValue)
            $0.text = vm.selectData?.isoCode ?? "ISO Code"
        }
        
        let countryLabel = UILabel().then {
            $0.font = .systemFont(ofSize: 16)
            $0.textColor = UIColor(named: CommonUtils.CustomColor.secondaryTextColor.rawValue)
            $0.text = vm.selectData?.countryName ?? "Country Name"
        }
        
        let basicCurrencyLabel = UILabel().then {
            $0.font = .systemFont(ofSize: 16)
            $0.textColor = UIColor(named: CommonUtils.CustomColor.secondaryTextColor.rawValue)
            $0.text = "USD $1 = \(CommonUtils.formatCurrency(rate: vm.selectData?.rate ?? 0, isoCode: vm.selectData?.isoCode ?? "", digit: 4))"
        }
        
        amountTextField.delegate = self
        
        convertButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            self.CalculatorCurrency()
        }, for: .touchUpInside)
        
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
    let vm = WorldCurrencyViewmodel()
    CurrencyCalculator(viewModel: vm)
}
