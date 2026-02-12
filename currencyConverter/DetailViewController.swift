//
//  DetailViewController.swift
//  currencyConverter
//
//  Created by 손영빈 on 2/12/26.
//

import UIKit

class DetailViewController: UIViewController {
    
    var currency: String = ""
    var rate: Double = 0.0
    
    private let detailView = DetailView()
    
    override func loadView() {
        self.view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailView.config(code: currency)
    }
}
