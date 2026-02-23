//
//  CurrencyConverterViewController.swift
//  currencyConverter
//
//  Created by Hanjuheon on 2/23/26.
//

import UIKit

class BaseViewController: UIViewController {
    
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
