//
//  ㅡ먀ㅜ퍋ㅈ.swift
//  currencyConverter
//
//  Created by t2025-m0143 on 2/13/26.
//
import UIKit
import SnapKit

final class MainView: UIView {
    private let searchBar = UISearchBar()
    private lazy var listView = UICollectionView(frame: .zero, collectionViewLayout: makeCompsitionalLayout())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setAttributes()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: initial set
extension MainView {
    private func setAttributes() {
        backgroundColor = .white
        
        searchBar.placeholder = "통화 검색"
        searchBar.searchTextField.backgroundColor = .systemGray5
        searchBar.backgroundColor = .white
        searchBar.searchBarStyle = .minimal
        
        listView.showsVerticalScrollIndicator = false
    }
    
    private func setLayout() {
        addSubview(searchBar)
        addSubview(listView)
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
        
        listView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
}

//MARK: listView
extension MainView {
    private func makeCompsitionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, environment in
            let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
            let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: environment)
            return section
        }
    }
    
    func passListView() -> UICollectionView {
        return listView
    }
}
