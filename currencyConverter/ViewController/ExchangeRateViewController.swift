//
//  ViewController.swift
//  currencyConverter
//
//  Created by 손영빈 on 2/12/26.
//

import UIKit

class ExchangeRateViewController: UIViewController {
    
    private let exchangeView = ExchangeView()
    private let viewModel = ExchangeRateViewModel()
    
    override func loadView() {
        self.view = exchangeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let favoriteManager = FavoriteManager(container: appDelegate.persistentContainer)
        let historyManager = HistoryManager(container: appDelegate.persistentContainer)
        viewModel.favoriteManager = favoriteManager
        viewModel.historyManager = historyManager
        
        self.title = "환율 정보"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        setDelegate()
        updateUI()
        viewModel.getCurrencyData()
    }
}

extension ExchangeRateViewController {
    private func updateUI() {
        viewModel.updateData = { [weak self] in
            DispatchQueue.main.async {
                self?.exchangeView.tableView.reloadData()
            }
        }
    }
}


extension ExchangeRateViewController {
    private func setDelegate() {
        exchangeView.searchBar.delegate = self
        
        exchangeView.tableView.delegate = self
        exchangeView.tableView.dataSource = self
        exchangeView.tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.id)
    }
}

extension ExchangeRateViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = viewModel.getItem(index: indexPath.row)
        
        let calculatorVM = CalculatorViewModel(item: item)
        let calculatorVC = CalculatorViewController(viewModel: calculatorVM)
        
        self.navigationController?.pushViewController(calculatorVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}
extension ExchangeRateViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.isDataEmpty {
            let emptyLabel = UILabel()
            emptyLabel.text = "검색 결과 없음"
            emptyLabel.textAlignment = .center
            tableView.backgroundView = emptyLabel
        } else {
            tableView.backgroundView = nil
        }
        return viewModel.dataCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.id) as? TableViewCell else { return UITableViewCell() }
        let item = viewModel.getItem(index: indexPath.row)
        let isFavorite = viewModel.isFavorite(code: item.code)
        cell.delegate = self
        cell.config(item: item, isSelected: isFavorite)
        return cell
    }
}

extension ExchangeRateViewController: TableViewCellDelegate {
    func didTapStarButton(cell: TableViewCell) {
        guard let indexPath = exchangeView.tableView.indexPath(for: cell) else { return }
        let item = viewModel.getItem(index: indexPath.row)
        viewModel.toggleFavorite(code: item.code)
    }
}

extension ExchangeRateViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.search(searchText: searchText)
    }
}

