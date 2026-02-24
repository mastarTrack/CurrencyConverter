//
//  ViewController.swift
//  currencyConverter
//
//  Created by t2025-m0143 on 2/10/26.
//

import UIKit

class ViewController: UIViewController {

    private let mainView = MainView()
    private lazy var dataSource = makeCollectionViewDiffableDataSource(mainView.listView)
    
    private let viewModel = MainViewModel()
    
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        viewModel.deleteAllBookMark()
        setNavigationController()
        mainView.searchBar.delegate = self
        mainView.listView.delegate = self
        setViewModelClosure()
    }
    
    // viewModel 초기 클로저 설정
    private func setViewModelClosure() {
        viewModel.update = { [weak self] (data: [Rate]) in
            self?.setSnapshot(with: data)
        }
        
        viewModel.alert = { [weak self] alertType in
            let alert = UIAlertController(status: alertType)
            self?.present(alert, animated: true)
        }
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
        viewModel.update = { [weak self] data in
            guard let self else { return }
            
            // 검색 결과가 없을 경우 noResultView 노출
            data.isEmpty ? mainView.showNoResultView(true) :
            mainView.showNoResultView(false)
            
            self.setSnapshot(with: data)
        }
        
        viewModel.searchData(searchText)
    }
}

//MARK: set listView
extension ViewController {
    // listView DiffableDataSource 설정
    private func makeCollectionViewDiffableDataSource(_ collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<Section, Rate> {
        let listCellRegistration = UICollectionView.CellRegistration<ListViewCell, Rate> { [weak self] cell, indexPath, rate in
            guard let self else { return }
            guard let data = self.viewModel.observedData?[indexPath.row] else { return }
            
            // 셀 설정
            let value = self.viewModel.fetchValueStringData(of: rate)
            cell.configure(rate, value: value)
            
            let action = UIAction { [weak self] _ in
                print("selected: \(rate.currencyCode)")
            }
            
            cell.starButton.addAction(action, for: .touchUpInside)
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
    
}

extension ViewController: UICollectionViewDelegate {
    // 컬렉션뷰 셀 선택 시 CalculationVC push
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = viewModel.observedData?[indexPath.row]
        guard let data else { return }
        
        let calculationVM = CalculationViewModel(data: data)
        
        self.navigationController?.pushViewController(CalculationViewController(viewModel: calculationVM), animated: true)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
}
