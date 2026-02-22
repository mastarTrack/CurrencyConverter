//
//  ExchangeRateViewController.swift
//  currencyConverter
//
//  Created by 김주희 on 2/17/26.
//

import UIKit
import SnapKit
import Then

class ExchangeRateViewController: UIViewController {
    
    // MARK: -- View,VM 인스턴스 생성
    private let mainView = MainView()
    private let viewModel: ExchangeRateViewModel
    
    // 테이블 뷰를 그리기 위한 내부 데이터
    var tableViewData: [ExchangeRateViewModel.SimpleRate] = []
    
    // 초기화
    init(viewModel: ExchangeRateViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: -- 초기화
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupDelegates()
        bindingData()
        viewModel.action?(.viewDidLoad)
    }
    
    
    // MARK: -- delegate 설정
    private func setupDelegates() {
        mainView.searchBar.delegate = self
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    
    
    // MARK: -- 메서드 정의
    // 데이터 바인딩
    private func bindingData() {
        // VM->View
        viewModel.stateChanged = { [weak self] state in
            DispatchQueue.main.async {
                self?.render(state)
            }
        }
    }
    
    // state 상태에 따라 View 렌더링하기
    private func render(_ state: ExchangeRateViewModel.State) {
        switch state {
        case .none:
            break
            
        case .success(let rates):
            self.tableViewData = rates
            self.mainView.tableView.reloadData()
            self.mainView.emptyLabel.isHidden = !rates.isEmpty
            
        case .error(let message):
            showErrorAlert(message: message)
        }
    }
}


// MARK: -- extension (UIViewController, UITableView, UISearchBar)

extension UIViewController {
    // 에러 알럿 표시 메서드
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "오류", message: "데이터를 불러올 수 없습니다", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        self.present(alert, animated: true)
    }
}

extension ExchangeRateViewController: UITableViewDataSource, UITableViewDelegate {
    // 셀 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
    
    // 셀에 그릴 것
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExchangeRateTableViewCell.id, for: indexPath) as? ExchangeRateTableViewCell else {
            return UITableViewCell()
        }
        
        let currencyData = tableViewData[indexPath.row]
        
        // 통화 코드
        let currencyName = currencyData.currencyCode
        
        // 국가명
        let countryName = CountryDictionary.countryDictionary[currencyName] ?? "알 수 없음"
        
        // 포맷팅된 환율 넣기
        let formattedRate = String(format: "%.4f", currencyData.rate)
        
        // 테이블 뷰 셀에 데이터 집어넣기
        cell.configure(code: currencyName, rate: formattedRate, country: countryName)
        
        return cell
    }
    
    // 테이블 뷰 셀 터치했을때 실행되는 함수
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 터치한 셀 배경 지우기
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 선택된 데이터 가져오기
        let selectedData = tableViewData[indexPath.row]
        let selectedCountry = CountryDictionary.countryDictionary[selectedData.currencyCode] ?? "알 수 없음"
        let selectedRate = String(format: "%.4f", selectedData.rate)
        
        // 의존성 주입
        let calcViewModel = CalculatorViewModel(code: selectedData.currencyCode, country: selectedCountry, rate: selectedRate)
        
        // CalculatorViewController 생성 및 이동
        let nextVC = CalculatorViewController(viewModel: calcViewModel)
        // 화면 이동
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
}

extension ExchangeRateViewController: UISearchBarDelegate {
    
    // textDidChange -> 글자가 한 글자라도 타이핑 될 때 마다 실행됨
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.action?(.filter(text: searchText))
    }
    
    // 키보드에서 검색 버튼 눌렀을때
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // 키보드 내려감
    }
}


#Preview {
    let dummyViewModel = ExchangeRateViewModel()
    return ExchangeRateViewController(viewModel: dummyViewModel)
}
