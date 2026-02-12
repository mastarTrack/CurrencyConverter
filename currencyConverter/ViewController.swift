//
//  ViewController.swift
//  currencyConverter
//
//  Created by 손영빈 on 2/12/26.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    private var dataSource: [(code: String, rate: Double)] = []
    
    private let mainView = MainView()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        getCurrencyData()
    }
}


extension ViewController {
    private func setDelegate() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.id)
    }
}

extension ViewController: UITableViewDelegate {
    
}
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.id) as? TableViewCell else { return UITableViewCell() }
        let item = dataSource[indexPath.row]
        cell.config(code: item.code, rate: item.rate)
        return cell
    }
}

extension ViewController {
    private func fetchData<T: Decodable>(url: URL, completion: @escaping(Result<T,AFError>) -> Void) {
        AF.request(url).responseDecodable(of: T.self) { response in
            completion(response.result)
        }
    }
    
    private func getCurrencyData() {
        guard let url = URL(string: "https://open.er-api.com/v6/latest/USD") else {
            print("잘못된 URL")
            return
        }
        fetchData(url: url) { [weak self] (result: Result<CurrencyResponse,AFError>) in
            guard let self else { return }
            switch result {
            case .success(let result):
                let sortedRates = result.rates.sorted{ $0.key < $1.key }
                self.dataSource = sortedRates.map { (code: $0.key, rate: $0.value) }
                DispatchQueue.main.async {
                    self.mainView.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

