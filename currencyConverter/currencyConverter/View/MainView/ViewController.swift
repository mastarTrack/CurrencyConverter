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
    // listView DiffableDataSource 설정
    private func makeCollectionViewDiffableDataSource(_ collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<Section, Rate> {
        let listCellRegistration = UICollectionView.CellRegistration<ListViewCell, Rate> { cell, indexPath, rate in
            let (code, country, value) = self.mainVM.fetchRateStringData(of: indexPath)
            cell.configure(code: code, country: country, rate: value)
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
        
        mainVM.alert = { [weak self] alertType in
            let alert = UIAlertController(status: alertType)
            self?.present(alert, animated: true)
        }
        
        mainVM.fetchData()
    }
}

extension ViewController: UICollectionViewDelegate {
    // 컬렉션뷰 셀 선택 시 CalculationVC push
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = mainVM.fetchRateData(of: indexPath)
        guard let data else { return }
        
        let calculationVM = CalculationViewModel()
        calculationVM.setInitialData(data)
        
        self.navigationController?.pushViewController(CalculationViewController(viewModel: calculationVM), animated: true)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
