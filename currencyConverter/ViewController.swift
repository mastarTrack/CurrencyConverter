//
//  ViewController.swift
//  currencyConverter
//
//  Created by 손영빈 on 2/12/26.
//

import UIKit

class ViewController: UIViewController {
    
    private let mainView = MainView()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
    }
}


extension ViewController {
    private func setDelegate() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
}

extension ViewController: UITableViewDelegate {
    
}
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
}

