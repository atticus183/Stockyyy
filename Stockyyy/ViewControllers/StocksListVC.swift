//
//  StocksListVC.swift
//  Stockyyy
//
//  Created by Josh R on 11/13/20.
//

import UIKit

protocol StocksListVCDelegate: class {
    func tickerTapped(_ company: CompanyJSON)
}

final class StocksListVC: UIViewController {

    lazy var stocksNetworkManager = StocksNetworkManager()
    
    weak var delegate: StocksListVCDelegate?
    var datasource: StocksDatasource?
    
    lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Search"
        //set to the navigationItem in the setupNavBar method
        
        return sc
    }()
    
    private let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .insetGrouped)
        tv.backgroundColor = .systemBackground
        tv.accessibilityIdentifier = "StocksListVC_Table"
        tv.register(StockCell.self, forCellReuseIdentifier: StockCell.identifier)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .systemBackground
        
        setupNavBar()
        setupTableView()
        
        CustomActivityView.startActivityView()
        stocksNetworkManager.getData(for: CompanyJSON.self, from: .stockList) { [weak self] (result) in
            switch result {
            case .success(let companyJSON):
                DispatchQueue.main.async {
                    CustomActivityView.stopActivityView()
                    self?.datasource = StocksDatasource(companies: companyJSON)
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
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        self.navigationItem.searchController = searchController
        
        let titleColor: UIColor = #colorLiteral(red: 0.1290173531, green: 0.5882815123, blue: 0.9528221488, alpha: 1)
        let navBarColor: UIColor = .systemBackground
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = navBarColor
        appearance.shadowColor = .none  //removes the nav bar border line
        appearance.titleTextAttributes = [.foregroundColor: titleColor]
        appearance.largeTitleTextAttributes = [.foregroundColor: titleColor]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance // For iPhone small navigation bar in landscape.
    }
    
    private func setupTableView() {
        self.view.addSubview(tableView)
        
        //MARK: TableView Delegate
        tableView.delegate = self
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 2)
        ])
    }
    
}

extension StocksListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let tappedCompany = datasource?.company(at: indexPath) else { return }
        
        stocksNetworkManager.getData(for: CompanyJSON.self, from: .companyProfile(tappedCompany.symbol)) { [weak self] (result) in
            switch result {
            case .success(let companyJSON):
                DispatchQueue.main.async {
                    self?.delegate?.tickerTapped(companyJSON.first!)
                    guard let companyInfoVC = self?.delegate as? CompanyInfoVC else { return }
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

//MARK: Search Delegate
extension StocksListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        
        datasource?.searchForCompany(with: searchText)
        tableView.reloadData()
    }
}
