//
//  StocksDatasource.swift
//  Stockyyy
//
//  Created by Josh R on 11/13/20.
//

import RealmSwift
import UIKit

enum Section: CaseIterable {
    case main
}

final class StocksDatasource: NSObject {
    
    private var diffableDataSource: UITableViewDiffableDataSource<Section, Company>?
    
    private var allCompanies: Results<Company>?
    
    private let tableView: UITableView
    
    init(in tableView: UITableView) {
        self.tableView = tableView
        super.init()
        loadDatasource()
    }
    
    private func loadDatasource() {
        diffableDataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, company) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: StockCell.identifier, for: indexPath) as? StockCell else { return UITableViewCell() }
            
            return cell
        })
        
        createSnapshot()
    }
    
    private func createSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Company>()
        
        //Create Sections first
        let sections = Section.allCases
        sections.forEach{( snapshot.appendSections([$0]) )}
        
        allCompanies?.forEach({ snapshot.appendItems( [$0]) })
        
        diffableDataSource?.apply(snapshot, animatingDifferences: true, completion: nil)
    }

}
