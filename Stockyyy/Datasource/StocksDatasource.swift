//
//  StocksDatasource.swift
//  Stockyyy
//
//  Created by Josh R on 11/13/20.
//

import UIKit


final class StocksDatasource: NSObject, UITableViewDataSource {
 
    private var allCompanies: [CompanyJSON]
    private var filteredCompanies = [CompanyJSON]()
    
    private var isSearching = false
    
    func company(at indexPath: IndexPath) -> CompanyJSON? {
        return isSearching ? filteredCompanies[indexPath.row] : allCompanies[indexPath.row]
    }
    
    func searchForCompany(with searchText: String) {
        isSearching = searchText == "" ? false : true
        
        if isSearching {
            filteredCompanies = allCompanies.filter({ (company) -> Bool in
                let exchange = company.exchange ?? ""
                let name = company.name ?? ""
                
                let isFound = company.symbol.lowercased().contains(searchText.lowercased())
                                || exchange.lowercased().contains(searchText.lowercased())
                                || name.lowercased().contains(searchText.lowercased())
                
                return isFound
            })
        } else {
            filteredCompanies.removeAll()
        }
    }
    
    init(companies: [CompanyJSON]) {
        self.allCompanies = companies.sorted(by: { $0.symbol < $1.symbol })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredCompanies.count : allCompanies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StockCell.identifier, for: indexPath) as? StockCell else { return UITableViewCell() }
        
        let company = isSearching ? filteredCompanies[indexPath.row] : allCompanies[indexPath.row]
        cell.company = company
        
        return cell
    }
}
