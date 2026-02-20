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
    private let emptyResultView = UIView()
    
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
        
        emptyResultView.backgroundColor = .white
        emptyResultView.isHidden = true
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
        
        
        let emptyResultLabel = makeEmptyResultLabel()
        addSubview(emptyResultView)
        emptyResultView.addSubview(emptyResultLabel)
        
        emptyResultView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        
        emptyResultLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

//MARK: searchBar
extension MainView {
    func setSearchBarDelegate(_ delegate: UISearchBarDelegate) {
        searchBar.delegate = delegate
    }
    
    func setListViewDelegate(_ delegate: UICollectionViewDelegate) {
        listView.delegate = delegate
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

//MARK: noSearchResultView
extension MainView {
    private func makeEmptyResultLabel() -> UILabel {
        let label = UILabel()
        label.text = "검색 결과 없음"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .systemGray3
        return label
    }
    
    func showNoResultView(_ show: Bool) {
        if show {
            emptyResultView.isHidden = false
            listView.isHidden = true
        } else {
            emptyResultView.isHidden = true
            listView.isHidden = false
        }
    }
}
