//
//  ViewController.swift
//  currencyConverter
//
//  Created by t2025-m0143 on 2/10/26.
//

import UIKit
import SnapKit

final class ViewController: UIViewController {
    private let currencyView = CurrencyTableView()
    private let currencyViewModel = CurrencyViewModel()
    private let searchBar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        navigationItem.title = "환율 정보"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        bindViewModel()
        
        configureSearchBar()
        configureCurrencyView()
        
        currencyViewModel.fetchCurrencyData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        CoreDataManager.shared.saveLastScreen(.list, selectedCurrency: nil)
    }
    
    private func configureCurrencyView() {
        view.addSubview(currencyView)
        
        currencyView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureSearchBar() {
        searchBar.placeholder = "통화 검색"
        searchBar.delegate = self
        
        view.addSubview(searchBar)
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        currencyViewModel.upDate = { [weak self] items in
            guard let self else { return }
            self.currencyView.update(newItems: items)
        }
        
        currencyViewModel.onError = { [weak self] message in
            self?.showErrorAlert(message: message)
        }
        
        currencyView.onSelectItem = { [weak self] item in
            guard let self else { return }
            self.showRateCalculator(for: item)
        }
    }
    
    private func showRateCalculator(for item: Item) {
        let viewModel = RateCalculatorViewModel(selectedItem: item)
        let viewController = RateCalculatorViewController(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "오류",
            message: message,
            preferredStyle: .alert
        )

        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)
        
        present(alert, animated: true)
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        currencyViewModel.filterCurrency(with: searchText)
    }
}
