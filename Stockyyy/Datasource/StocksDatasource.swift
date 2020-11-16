//
//  StocksDatasource.swift
//  Stockyyy
//
//  Created by Josh R on 11/13/20.
//

import UIKit


final class StocksDatasource: NSObject, UITableViewDataSource {
 
    private var allCompanies: [CompanyJSON]
    
    func company(at indexPath: IndexPath) -> CompanyJSON? {
        return allCompanies[indexPath.row]
    }
    
    init(companies: [CompanyJSON]) {
        self.allCompanies = companies.sorted(by: { $0.symbol! < $1.symbol! })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allCompanies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StockCell.identifier, for: indexPath) as? StockCell else { return UITableViewCell() }
        
        cell.company = allCompanies[indexPath.row]
        
        return cell
    }
}
