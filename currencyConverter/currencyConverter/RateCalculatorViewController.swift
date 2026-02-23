//
//  RateCalculator.swift
//  currencyConverter
//
//  Created by Yeseul Jang on 2/23/26.
//

import UIKit
import SnapKit

final class RateCalculatorViewController: UIViewController {
    private let rateCalculatorView = RateCalculatorView()
    private let viewModel: RateCalculatorViewModel

    init(viewModel: RateCalculatorViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configure()
        bindViewModel()
        bindActions()
    }
    
    private func bindViewModel() {
        rateCalculatorView.configure(item: viewModel.item)
    }
    
    private func bindActions() {
        rateCalculatorView.tapConvertButton { [weak self] in
            guard let self else { return }
            do {
                let input = self.rateCalculatorView.amountText
                let result = try self.viewModel.calculate(input: input)
                self.rateCalculatorView.setResultLabel(result)
            } catch {
                showAlert(message: error.localizedDescription)
            }
        }
    }
    
    private func configure() {
        view.addSubview(rateCalculatorView)
        
        rateCalculatorView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(
            title: "입력 오류",
            message: message,
            preferredStyle: .alert
        )

        let action = UIAlertAction(title: "확인", style: .default)
        alert.addAction(action)

        present(alert, animated: true)
    }
}
