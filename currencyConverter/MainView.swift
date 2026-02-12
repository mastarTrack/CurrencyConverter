//
//  MainView.swift
//  currencyConverter
//
//  Created by 손영빈 on 2/12/26.
//

import UIKit
import SnapKit

class MainView: UIView {
    
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

extension MainView {
    private func setAttributes() {
        self.backgroundColor = .systemBackground
        
    }
    private func setLayout() {
        
        [tableView].forEach { addSubview($0) }
        
        tableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
    }
}
