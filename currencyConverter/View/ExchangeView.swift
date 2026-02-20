//
//  MainView.swift
//  currencyConverter
//
//  Created by 손영빈 on 2/12/26.
//

import UIKit
import SnapKit

class ExchangeView: UIView {
    
    let searchBar = UISearchBar()
    let tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAttributes()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ExchangeView {
    private func setAttributes() {
        self.backgroundColor = .backgroundColor
        
        tableView.backgroundColor = .backgroundColor
        
        searchBar.placeholder = "통화 검색"
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = .backgroundColor
        searchBar.searchTextField.backgroundColor = .cellBackgroundColor
        
    }
    private func setLayout() {
        
        [searchBar, tableView].forEach { addSubview($0) }
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
    }
}
