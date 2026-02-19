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

        updateListView()
    }
}

//MARK: set listView
extension ViewController {
    private func convertValueToString(_ value: Double) -> String {
        return String(format: "%4f", value)
    }
    
    private func updateListView() {
        getData { data in
            self.setSnapshot(data)
        }
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
    
    private func setSnapshot(_ data: [Rate]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Rate>()
        snapShot.appendSections([.main])
        snapShot.appendItems(data, toSection: .main)
        dataSource.apply(snapShot)
    }
    
    private func getData(completion: @escaping ([Rate]) -> Void) {
        dataService.fetchCurrencyData(currency: "USD") { result in
            guard let result else {
                print("데이터를 불러올 수 없습니다")
                return
            }
            
            let rates = result.rates.reduce(into: []) {
                $0.append(Rate(name: $1.key, value: $1.value))
            }
            
            completion(rates)
        }
    }
}
