//
//  AlertController.swift
//  currencyConverter
//
//  Created by t2025-m0143 on 2/20/26.
//
import UIKit

extension UIAlertController {
    convenience init(status: AlertType) {
        self.init(title: "오류", message: status.rawValue, preferredStyle: .alert)
        
        let confirm = UIAlertAction(title: "확인", style: .default)
        addAction(confirm)
    }
}
