//
//  MainView.swift
//  currencyConverter
//
//  Created by 김주희 on 2/20/26.
//

import UIKit
import SnapKit
import Then

class MainView: UIView {
    
    // MARK: -- 메인 View UI 컴포넌트 선언
    // 서치 바
    let searchBar = UISearchBar().then {
        $0.searchTextField.placeholder = "통화 검색"
        $0.searchTextField.backgroundColor = .systemGray5
    }
    
    // 테이블 뷰
    let tableView = UITableView().then {
        $0.register(ExchangeRateTableViewCell.self, forCellReuseIdentifier: ExchangeRateTableViewCell.id)
    }

    // 검색 결과 없음 화면
    let emptyLabel = UILabel().then {
        $0.text = "검색 결과 없음"
        $0.textColor = .gray
        $0.font = .systemFont(ofSize: 25, weight: .regular)
        $0.textAlignment = .center
        $0.isHidden = true
    }
    
    
    // MARK: -- 초기화
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: -- addSubview, Snapkit
    private func setupLayout() {
        
        [searchBar, tableView, emptyLabel].forEach {
            self.addSubview($0)
        }

        searchBar.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
        }

        emptyLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
    }
}


#Preview {
    let dummyViewModel = ExchangeRateViewModel()
    return ExchangeRateViewController(viewModel: dummyViewModel)
}
