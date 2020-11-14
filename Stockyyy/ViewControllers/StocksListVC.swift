//
//  StocksListVC.swift
//  Stockyyy
//
//  Created by Josh R on 11/13/20.
//

import UIKit

protocol StocksListVCDelegate: class {
    func stockTapped(_ stock: String)   //TODO: Change this to the stock type
}

class StocksListVC: UIViewController {
    
    weak var delegate: StocksListVCDelegate?
    
    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.backgroundColor = .systemBackground
        //TODO: Register cell
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
        setupNavBar()
        setupTableView()
    }
    
    private func setupNavBar() {
        self.title = "Stocks"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
    }
    
    private func setupTableView() {
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0)
        ])
    }
    
}
