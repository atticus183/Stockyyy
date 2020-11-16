//
//  StocksListVC.swift
//  Stockyyy
//
//  Created by Josh R on 11/13/20.
//

import UIKit
import RealmSwift

protocol StocksListVCDelegate: class {
    func stockTapped(_ company: Company)
}

final class StocksListVC: UIViewController {
    
    var realm: Realm?
    
    lazy var stocksNetworkManager = StocksNetworkManager.shared
    
    weak var delegate: StocksListVCDelegate?
    var datasource: StocksDatasource?
    
    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.backgroundColor = .systemBackground
        tv.register(StockCell.self, forCellReuseIdentifier: StockCell.identifier)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        realm = MyRealm.getConfig()
//        try! realm?.write {
//            realm?.deleteAll()
//        }
        
        print("Realm file path: \(String(describing: realm?.configuration.fileURL))")
        
        self.view.backgroundColor = .systemBackground
        
        setupNavBar()
        setupTableView()
        
        CustomActivityView.startActivityView()
        stocksNetworkManager.getData(from: .stockList) { [weak self] (result) in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    CustomActivityView.stopActivityView()
                    self?.datasource = StocksDatasource()
                    self?.tableView.dataSource = self?.datasource
                    self?.tableView.reloadData()
                }
            case .failure:
                DispatchQueue.main.async {
                    CustomActivityView.stopActivityView()
                }
            }
        }
    }
    
    private func setupNavBar() {
        self.title = "Stocks"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
    }
    
    private func setupTableView() {
        self.view.addSubview(tableView)
        
        //MARK: TableView Delegate
        tableView.delegate = self
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0)
        ])
    }
    
}

extension StocksListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let tappedCompany = datasource?.company(at: indexPath) else { return }
        
        stocksNetworkManager.getData(from: .companyProfile(tappedCompany.symbol)) { [weak self] (result) in
            switch result {
            case .success():
                DispatchQueue.main.async {
                    guard let closureRealm = MyRealm.getConfig() else { return }
                    guard let company = closureRealm.objects(Company.self).filter("symbol == %d", tappedCompany.symbol).first else { return }
                    self?.delegate?.stockTapped(company)
                    guard let companyInfoVC = self?.delegate as? CompanyInfoVC else { return }
                    //        guard let companyInfoVCNavigationController = companyInfoVC.navigationController else { return }
                    self?.splitViewController?.showDetailViewController(companyInfoVC, sender: nil)
                }
            case .failure(let error):
                print("Error: \(error.errorDescription)")
                DispatchQueue.main.async {
                    CustomActivityView.stopActivityView()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
}
