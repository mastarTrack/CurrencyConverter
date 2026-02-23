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
    
    private let mainVM = MainViewModel()
    
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
        mainVM.update = { [weak self] data in
            guard let self else { return }
            
            // 검색 결과가 없을 경우 noResultView 노출
            data.isEmpty ? mainView.showNoResultView(true) :
            mainView.showNoResultView(false)
            
            self.setSnapshot(with: data)
        }
        
        mainVM.searchData(searchText)
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
    
    private func setData() {
        mainVM.update = { [weak self] (data: [Rate]) in
            self?.setSnapshot(with: data)
        }
        mainVM.fetchData()
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
