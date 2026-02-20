//
//  ViewController.swift
//  currencyConverter
//
//  Created by t2025-m0143 on 2/10/26.
//

import UIKit
import Then
import SnapKit

class WorldCurrencyViewController: UIViewController {
    
    //MARK: - ViewModel
    var vm = WorldCurrencyViewmodel()
    
    //MARK: - Components
    var collectionView: UICollectionView! = nil
    
    var searchBar = UISearchBar()
    
    //MARK: - INIT
    override func viewDidLoad() {
        super.viewDidLoad()
        vm.fatchWorldCurrency()
        setClosure()
        configureUI()
        // Do any additional setup after loading the view.
    }
}

//MARK: - Set ViewModel Closures
extension WorldCurrencyViewController {
    func setClosure() {
        vm.updateCurrencyClosure = { [weak self] in
            guard let self else { return }
            self.collectionView.reloadData()
        }
    }
}


//MARK: - METHOD: Configure CollectionView Datasource, Delegate
extension WorldCurrencyViewController: UICollectionViewDelegate, UICollectionViewDataSource {
     
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.manager.worldCurrencyDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrencyCell.identifier, for: indexPath) as! CurrencyCell
        let rate = vm.manager.worldCurrencyDatas[indexPath.item]
        cell.updateUI(isoCode: rate.isoCode, countryName: rate.countryName, rate: vm.manager.formatCurrency(rate: rate.rate, isoCode: rate.isoCode))
        return cell
    }
}

//MARK: - METHOD: Configure Custom CollectionView Section
extension WorldCurrencyViewController {
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
    func configureUI() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(section: currencySection()))
        collectionView.register(CurrencyCell.self, forCellWithReuseIdentifier: CurrencyCell.identifier)
        collectionView.dataSource = self
        
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
