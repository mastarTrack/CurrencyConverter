//
//  CurrencyTableView.swift
//  
//
//  Created by Yeseul Jang on 2/19/26.
//
import Foundation
import UIKit
import SnapKit

// 접근제한자 쓰기
// 주석 자세히 적기
// 트러블 슈팅 간단하게라도 적어두기
// MVVM 역할 분담 나누기(이유 작성)

struct Item: Hashable {
    let currency: String
    let rate: String
}

final class CurrencyTableView: UIView {
    
    private var items: [Item] = []
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.register(ListCell.self, forCellWithReuseIdentifier: ListCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func update(newItems: [Item]) {
        self.items = newItems
        collectionView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeLayout() -> UICollectionViewLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.showsSeparators = true
        
        return UICollectionViewCompositionalLayout.list(using: config)
    }
}

extension CurrencyTableView: UICollectionViewDelegate {
    
}

extension CurrencyTableView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCell.identifier, for: indexPath) as? ListCell else {
            print("오류")
            return UICollectionViewCell()
        }
        let item = items[indexPath.item]
        cell.setData(item: item)
        return cell
    }
}

final class ListCell: UICollectionViewCell {
    static let identifier = "ListCell"
    
    private let currency = UILabel()
    private let rate = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .clear
        contentView.addSubview(currency)
        contentView.addSubview(rate)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        currency.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(30)
        }
        
        rate.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(30)
        }
    }
    
    func setData(item: Item) {
        currency.text = item.currency
        rate.text = item.rate
    }
}

