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
    
    private var favoriteSet: Set<String> = []
    
    private let emptyLabel = UILabel().then {
        $0.text = "검색 결과 없음"
        $0.textColor = .secondaryLabel
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 18)
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(ListCell.self, forCellWithReuseIdentifier: ListCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func update(newItems: [Item]) {
        
        favoriteSet = CoreDataManager.shared.fetchAllFavoriteCurrencies()
        var updatedItems: [Item] = []
        
        for newItem in newItems {
            var updatedItem = newItem
            
            if favoriteSet.contains(newItem.currency) {
                updatedItem.isFavorite = true
            } else {
                updatedItem.isFavorite = false
            }
            
            updatedItems.append(updatedItem)
        }
        
        self.items = sortFavoriteFirst(updatedItems)
        collectionView.reloadData()
        
        if self.items.isEmpty {
            collectionView.backgroundView = emptyLabel
        } else {
            collectionView.backgroundView = nil
        }
    }
    
    private func sortFavoriteFirst(_ items: [Item]) -> [Item] {
        items.sorted {
            if $0.isFavorite != $1.isFavorite { return $0.isFavorite && !$1.isFavorite }
            return $0.currency < $1.currency
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
    
    // 셀에서 받은 정보로 즐겨찾기 바꿔주기
    private func setFavorite(_ isFavorite: Bool, item: Item) {
        if isFavorite {
            CoreDataManager.shared.addFavorite(currency: item.currency)
        } else {
            CoreDataManager.shared.removeFavorite(currency: item.currency)
        }
        
        favoriteSet = CoreDataManager.shared.fetchAllFavoriteCurrencies()
        
        if let index = items.firstIndex(where: { $0.currency == item.currency }) {
            items[index].isFavorite = isFavorite
            
            // 정렬 후 보여주기
            items = sortFavoriteFirst(items)
            collectionView.reloadData()
        }
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
        
        // cell에서 즐겨찾기 상태 바뀔때마다 호출해서 셀에 해당 정보 받아옴
        cell.onTapFavorite = { [weak self] tappedItem, isFavorite in
            self?.setFavorite(isFavorite, item: tappedItem)
        }
        
        return cell
    }
}
