//
//  CustomButton.swift
//  currencyConverter
//
//  Created by Yeseul Jang on 2/24/26.
//
import Foundation
import UIKit
import SnapKit
import Then

// 버튼이 선택됨
// 해당 셀의 아이템 정보 저장해서 뷰컨 거쳐서 뷰모델로..??
// 콜렉션 뷰에서 맨 위로 보냄

final class CustomButton: UIControl {
    private let imageView = UIImageView()
    
    override var isSelected: Bool {
        didSet { changeImage() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        isAccessibilityElement = true
        accessibilityTraits = [.button]
        
        addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(30)
            $0.center.equalToSuperview()
        }
        
        // 여기서는 .touchUpInside로 눌렸는지 표시만 해주는 역할
        // 뷰컨에선 for: .valueChanged 이런식으로 받아야함
        addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            self.isSelected.toggle()
            self.sendActions(for: .valueChanged)
        }, for: .touchUpInside)
    }
    
    private func setImage() {
        imageView.image = UIImage(systemName: "star")
        imageView.tintColor = .systemOrange
    }
    
    private func changeImage() {
        if isSelected {
            imageView.image = UIImage(systemName: "star.fill")
        } else {
            imageView.image = UIImage(systemName: "star")
        }
    }
}
