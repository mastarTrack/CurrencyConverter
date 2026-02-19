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
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setSnapshot()
    }
}

//MARK: set listView
extension ViewController {
    private func convertValueToString(_ value: Double) -> String {
        return String(format: "%4f", value)
    }
    
    private func makeCollectionViewDiffableDataSource(_ collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<Section, Rate> {
        let listCellRegistration = UICollectionView.CellRegistration<ListViewCell, Rate> { cell, indexPath, rate in
            let value = self.convertValueToString(rate.value)
            cell.configure(name: rate.name, value: value)
        }
        
        let dataSource = UICollectionViewDiffableDataSource<Section, Rate>(collectionView: collectionView) { collectionView, indexPath, rate in
            return collectionView.dequeueConfiguredReusableCell(using: listCellRegistration, for: indexPath, item: rate)
        }
        
        return dataSource
    }
    
    private func setSnapshot() {
        getData {
            var snapShot = NSDiffableDataSourceSnapshot<Section, Rate>()
            snapShot.appendSections([.main])
            snapShot.appendItems($0, toSection: .main)
            self.dataSource.apply(snapShot)
        }
    }
    
    private func getData(completion: @escaping ([Rate]) -> Void) {
        dataService.fetchCurrencyData(currency: "USD") { result in
            guard let result else {
                let alert = UIAlertController(title: "오류", message: "데이터를 불러올 수 없습니다.", preferredStyle: .alert)
                let confirm = UIAlertAction(title: "확인", style: .default)
                alert.addAction(confirm)
                self.present(alert, animated: true)
                return
            }
            
            let rates = result.rates.reduce(into: []) {
                $0.append(Rate(name: $1.key, value: $1.value))
            }
            
            completion(rates)
        }
    }
}
