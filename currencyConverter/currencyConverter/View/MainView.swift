//
//  ㅡ먀ㅜ퍋ㅈ.swift
//  currencyConverter
//
//  Created by t2025-m0143 on 2/13/26.
//
import UIKit
import SnapKit

final class MainView: UIView {
    private let listView = UICollectionView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainView {
    private func makeCompsitionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, environment in
            guard sectionIndex == 0 else { return }
            
        }
    }
}
