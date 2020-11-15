//
//  StocksListVC.swift
//  Stockyyy
//
//  Created by Josh R on 11/13/20.
//

import UIKit
import RealmSwift

protocol StocksListVCDelegate: class {
    func stockTapped(_ stock: String)   //TODO: Change this to the stock type
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
        try! realm?.write {
            realm?.deleteAll()
        }
        
        print("Realm file path: \(String(describing: realm?.configuration.fileURL))")
        
        self.view.backgroundColor = .systemBackground
        
        setupNavBar()
        setupTableView()
        
        stocksNetworkManager.getData(from: .stockList) { [weak self] (result) in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.datasource = StocksDatasource()
                    self?.tableView.dataSource = self?.datasource
                    self?.tableView.reloadData()
                }
            case .failure:
                break
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
        //TODO: Tap cell and pass data
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
}
