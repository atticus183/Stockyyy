//
//  StocksDatasource.swift
//  Stockyyy
//
//  Created by Josh R on 11/13/20.
//

import RealmSwift
import UIKit


final class StocksDatasource: NSObject, UITableViewDataSource {
    
    private var realm: Realm?
    
    private var allCompanies: Results<Company>?
    
    override init() {
        super.init()
        realm = MyRealm.getConfig()
        allCompanies = realm?.objects(Company.self).sorted(byKeyPath: "symbol", ascending: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allCompanies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StockCell.identifier, for: indexPath) as? StockCell else { return UITableViewCell() }
        
        cell.company = allCompanies?[indexPath.row]
        
        return cell
    }
}
