//
//  ViewController.swift
//  currencyConverter
//
//  Created by t2025-m0143 on 2/10/26.
//

import UIKit

class ViewController: UIViewController {

    private let mainView = MainView()
    private lazy var dataSource = makeCollectionViewDiffableDataSource(mainView.passListView())
    
    private let dataService = DataService()
    private var data: [Rate]?
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.setSearchBarDelegate(self)
        setData()
    }
}

//MARK: searchBar Delegate
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let data else { return }
        
        if searchText.isEmpty { // 검색어가 비었을 경우
            mainView.showNoResultView(false)
            setSnapshot(with: data)
        } else {
            let searchedData = data.filter { $0.currencyCode.contains(searchText.uppercased()) || $0.country.contains(searchText) }

            // 검색 결과가 없을 경우 noResultView 노출
            searchedData.isEmpty ? mainView.showNoResultView(true) : mainView.showNoResultView(false)
            setSnapshot(with: searchedData)
        }
    }
}

//MARK: set listView
extension ViewController {
    private func convertValueToString(_ value: Double) -> String {
        return String(format: "%.4f", value)
    }
    
    private func makeCollectionViewDiffableDataSource(_ collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<Section, Rate> {
        let listCellRegistration = UICollectionView.CellRegistration<ListViewCell, Rate> { cell, indexPath, rate in
            let value = self.convertValueToString(rate.value)
            cell.configure(code: rate.currencyCode, country: rate.country, rate: value)
        }
        
        let dataSource = UICollectionViewDiffableDataSource<Section, Rate>(collectionView: collectionView) { collectionView, indexPath, rate in
            return collectionView.dequeueConfiguredReusableCell(using: listCellRegistration, for: indexPath, item: rate)
        }
        
        return dataSource
    }
    
    private func setSnapshot(with data: [Rate]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Rate>()
        snapShot.appendSections([.main])
        snapShot.appendItems(data, toSection: .main)
        self.dataSource.apply(snapShot)
    }
    
    private func setData() {
        dataService.fetchCurrencyData(currency: "USD") { result in
            guard let result else {
                let alert = UIAlertController(title: "오류", message: "데이터를 불러올 수 없습니다.", preferredStyle: .alert)
                let confirm = UIAlertAction(title: "확인", style: .default)
                alert.addAction(confirm)
                self.present(alert, animated: true)
                return
            }
            
            let rates = result.rates.reduce(into: []) {
                $0.append(Rate(currencyCode: $1.key, value: $1.value))
            }
            
            self.data = rates
            self.setSnapshot(with: rates)
        }
    }

}
