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
    private var originData: [Rate]? // 원본 데이터
    private var showingData: [Rate]? // 컬렉션뷰에 표시중인 데이터
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationController()
        mainView.setSearchBarDelegate(self)
        mainView.setListViewDelegate(self)
        setData()
    }
}

//MARK: navigation controller
extension ViewController {
    private func setNavigationController() {
        self.navigationItem.title = "환율 정보"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
}

//MARK: searchBar Delegate
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let originData else { return }
        
        if searchText.isEmpty { // 검색어가 비었을 경우
            mainView.showNoResultView(false)
            showingData = originData
        } else { // 검색어가 있을 경우
            let searchedData = originData.filter { $0.currencyCode.contains(searchText.uppercased()) || $0.country.contains(searchText) }
            showingData = searchedData
            
            // 검색 결과가 없을 경우 noResultView 노출
            searchedData.isEmpty ? mainView.showNoResultView(true) : mainView.showNoResultView(false)
        }
        
        guard let showingData else { return }
        setSnapshot(with: showingData)
    }
}

//MARK: set listView
extension ViewController {
    private func convertValueToString(_ value: Double) -> String {
        return String(format: "%.4f", value)
    }
    
    // listView DiffableDataSource 설정
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
    
    // 스냅샷 설정
    private func setSnapshot(with data: [Rate]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Rate>()
        snapShot.appendSections([.main])
        snapShot.appendItems(data, toSection: .main)
        self.dataSource.apply(snapShot)
    }
    
    // 초기 데이터 설정
    private func setData() {
        dataService.fetchCurrencyData(currency: "USD") { result in
            guard let result else {
                let alert = UIAlertController(status: .emptyData)
                self.present(alert, animated: true)
                return
            }
            
            let rates = result.rates.reduce(into: []) {
                $0.append(Rate(currencyCode: $1.key, value: $1.value))
            }
            
            self.originData = rates
            self.showingData = self.originData
            self.setSnapshot(with: rates)
        }
    }
}

extension ViewController: UICollectionViewDelegate {
    // 컬렉션뷰 셀 선택 시 CalculationVC push
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let data = self.showingData else { return }
        let rate = data[indexPath.row]
        
        self.navigationController?.pushViewController(CalculationViewController(data: rate), animated: true)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
