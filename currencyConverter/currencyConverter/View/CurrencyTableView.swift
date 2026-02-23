//
//  CurrencyTableView.swift
//  
//
//  Created by Yeseul Jang on 2/19/26.
//
import Foundation
import UIKit
import SnapKit
import Then

// 접근제한자 쓰기
// 주석 자세히 적기
// 트러블 슈팅 간단하게라도 적어두기
// MVVM 역할 분담 나누기(이유 작성)

final class CurrencyTableView: UIView {
    private var items: [Item] = []
    var onSelectItem: ((Item) -> Void)?
    
    private let emptyLabel = UILabel().then {
        $0.text = "검색 결과 없음"
        $0.textColor = .gray
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 18)
    }
    
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
        
        if newItems.isEmpty {
            collectionView.backgroundView = emptyLabel
        } else {
            collectionView.backgroundColor = nil
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(60)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 0
        section.contentInsets = .zero

        return UICollectionViewCompositionalLayout(section: section)
    }
}

extension CurrencyTableView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = items[indexPath.item]
        onSelectItem?(selectedItem)
    }
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
