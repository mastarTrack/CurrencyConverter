//
//  CurrencyConverterViewController.swift
//  currencyConverter
//
//  Created by Hanjuheon on 2/23/26.
//

import UIKit

/// 환율정보 및 계산기 기초 ViewController
class BaseViewController: UIViewController {
    
    /// 경고창 출력 메소드
    func showWarning(message: String) {
        let alert = UIAlertController(
            title: "경고",
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
