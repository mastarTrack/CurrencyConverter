//
//  ViewController.swift
//  currencyConverter
//
//  Created by 손영빈 on 2/12/26.
//

//TODO: Level 1. Alert 표시
//TODO: ViewModel 파일 만들기, //VC, VM, M
//VC: View update, Delegate (Model을 알면 안됨)
//VM: Model 데이터 가공, 로직 처리

import UIKit
import Alamofire

class ExchangeRateViewController: UIViewController {
    
    private var allData: [ExchangeRate] = []
    private var viewData: [ExchangeRate] = []
    
    private let exchangeView = ExchangeView()
    
    override func loadView() {
        self.view = exchangeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        getCurrencyData()
    }
}


extension ExchangeRateViewController {
    private func setDelegate() {
        exchangeView.searchBar.delegate = self
        
        exchangeView.tableView.delegate = self
        exchangeView.tableView.dataSource = self
        exchangeView.tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.id)
    }
}

extension ExchangeRateViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let calculatorVC = CalculatorViewController()
        calculatorVC.code = viewData[indexPath.row].code
        calculatorVC.rate = viewData[indexPath.row].rate
        
        self.navigationController?.pushViewController(calculatorVC, animated: true)
    }
}
extension ExchangeRateViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let text = exchangeView.searchBar.text, !text.isEmpty {
            let emptyLabel = UILabel()
            emptyLabel.text = "검색 결과 없음"
            emptyLabel.textAlignment = .center
            tableView.backgroundView = emptyLabel
        } else {
            tableView.backgroundView = nil
        }
        return viewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.id) as? TableViewCell else { return UITableViewCell() }
        let item = viewData[indexPath.row]
        cell.config(code: item.code, rate: item.rate)
        return cell
    }
}

extension ExchangeRateViewController {
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
                allData = sortedRates.map { ExchangeRate(code: $0.key, rate: $0.value) }
                viewData = allData
                DispatchQueue.main.async {
                    self.exchangeView.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension ExchangeRateViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewData = allData
        } else {
            viewData = allData.filter { item in
                let countryName = Mapper.getName(code: item.code)
                return item.code.uppercased().contains(searchText.uppercased()) || countryName.contains(searchText)
            }
        }
        exchangeView.tableView.reloadData()
    }
}

