import UIKit

protocol StocksListVCDelegate: AnyObject {
    func tickerTapped(_ company: CompanyJSON)
}

final class StocksListVC: UIViewController {
    
    //This class monitors the devices network connection
    private let networkManager = NetworkMonitor.shared
    
    private lazy var stocksNetworkManager = StocksNetworkManager()
    
    weak var delegate: StocksListVCDelegate?
    private var datasource: StocksDatasource?
    
    private lazy var searchController: UISearchController = {
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
    
    private lazy var networkUnavailableView = NetworkUnavailableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Start monitoring the devices network status
        networkManager.startMonitor()
        
        view.backgroundColor = .systemBackground
        
        setupNavBar()
        setupTableView()
        getStocks()
        
        networkManager.connectionDidChange = { [weak self] isConnected in
            guard let strongSelf = self else { return }
            
            if isConnected {
                strongSelf.getStocks()
            }
            
            //The NetworkManager runs on a custom queue.  Must push UI updates back to the main thread.
            DispatchQueue.main.async {
                strongSelf.navigationItem.titleView = strongSelf.networkManager.isConnected ? nil : strongSelf.networkUnavailableView
            }
        }
    }
    
    deinit {
        networkManager.stopMonitoring()
    }
    
    private func setupNavBar() {
        title = "Stocks"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchController
        navigationItem.titleView = networkManager.isConnected ? nil : networkUnavailableView
        
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
    
    private func getStocks() {
        //Push startActivityView method to main thread because this method is called within the networkManager closure on a custom queue.
        if networkManager.isConnected {
            DispatchQueue.main.async { CustomActivityView.startActivityView() }
            stocksNetworkManager.getData(for: CompanyJSON.self, from: .stockList) { [weak self] (result) in
                switch result {
                case .success(let companyJSON):
                    DispatchQueue.main.async {
                        CustomActivityView.stopActivityView()
                        self?.datasource = StocksDatasource(companies: companyJSON)
                        self?.tableView.dataSource = self?.datasource
                        self?.tableView.reloadData()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        CustomActivityView.stopActivityView()
                        self?.alert(message: "There was an error retrieving the symbols. \(error.errorDescription)", title: "ERROR")
                    }
                }
            }
        }
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
                DispatchQueue.main.async {
                    CustomActivityView.stopActivityView()
                    self?.alert(message: "There was an error retrieving the company profile. \(error.errorDescription)", title: "ERROR")
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
