//
//  ViewController.swift
//  currencyConverter
//
//  Created by t2025-m0143 on 2/10/26.
//

import UIKit
import Then
import SnapKit

class WorldCurrencyViewController: BaseViewController {
    
    //MARK: - ViewModel
    var vm: BaseViewModelProtocol
    
    //MARK: - Components
    var collectionView: UICollectionView! = nil
    var searchBar = UISearchBar()
    
    //MARK: - INIT
    init() {
        vm = WorldCurrencyViewmodel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "환율 정보"
        view.backgroundColor = UIColor(named: CommonUtils.CustomColor.background.rawValue)
        navigationItem.backButtonDisplayMode = .default
        setViewModelClosure()
        configureUI()
        // Do any additional setup after loading the view.
    }
}

//MARK: - METHOD: Set ViewModel Closures
extension WorldCurrencyViewController {
    /// ViewModel 클로져 선언 메소드
    func setViewModelClosure() {
        vm.updateCurrencyClosure = { [weak self] error in
            guard let self else { return }
            if let error = error {
                showWarning(message: error)
            }
            self.collectionView.reloadData()
        }
        
        vm.lastPageClosure = {[weak self] currencyData in
            guard let self else { return }
            let ccVC = CurrencyCalculatorViewController(currencyData: currencyData)
            navigationController?.pushViewController(ccVC, animated: true)
        }
    }
}

//MARK: - METHOD: Search bar Delegate
extension WorldCurrencyViewController: UISearchBarDelegate {
    /// searchBar 입력값 변환 처리 메소드
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        vm.fatchModelToSearch(searchText: searchText)
        collectionView.reloadData()
    }
    
}


//MARK: - METHOD: Configure CollectionView Datasource, Delegate
extension WorldCurrencyViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    /// CollectionView 셀 선택 값 처리 메소드
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ccVC = CurrencyCalculatorViewController(currencyData: vm.datas[indexPath.item])
        navigationController?.pushViewController(ccVC, animated: true)
    }
    
    /// CollectionView 섹션별 아이템 갯수 할당 메소드
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.datas.count
    }
    
    /// CollectionView 아이템 설정 메소드
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrencyCell.identifier, for: indexPath) as! CurrencyCell
        let rate = vm.datas[indexPath.item]
        cell.updateUI(isoCode: rate.isoCode, countryName: rate.countryName, rate: CommonUtils.formatCurrency(rate: rate.rate, isoCode: rate.isoCode, digit: 4), isFavorite: rate.favorites)
        cell.favoritesTouchClosure = {[weak self] isFavorite in
            guard let self else { return }
            vm.updateDataToFavorites(isoCode: rate.isoCode, isFavorite: isFavorite)
            self.collectionView.reloadData()
        }
        return cell
    }
}

//MARK: - METHOD: Configure Custom CollectionView Section
extension WorldCurrencyViewController {
    /// CollectionView Compositional Section 정의 메소드
    private func currencySection()-> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(60))
        )
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(60)), subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        return section
    }
}

//MARK: - METHOD: Configure
extension WorldCurrencyViewController {
    /// 초기 UI 설정 메소드
    func configureUI() {
        
        searchBar.delegate = self
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(section: currencySection()))
        collectionView.register(CurrencyCell.self, forCellWithReuseIdentifier: CurrencyCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.trailing.leading.equalToSuperview()
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

@available(iOS 17.0, *)
#Preview {
        WorldCurrencyViewController()
}
