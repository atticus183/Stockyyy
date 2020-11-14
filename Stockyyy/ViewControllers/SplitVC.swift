//
//  SplitVC.swift
//  Stockyyy
//
//  Created by Josh R on 11/13/20.
//

import UIKit

class SplitVC: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.preferredDisplayMode = .oneBesideSecondary
        
        let stocksListVC = StocksListVC()
        let companyInfoVC = CompanyInfoVC()
        
        stocksListVC.delegate = companyInfoVC
        
        self.setViewController(stocksListVC, for: .primary)
        self.setViewController(companyInfoVC, for: .secondary)
    }

}

extension SplitVC : UISplitViewControllerDelegate {
    //This method shows the master detail FIRST when on iPhone
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        return .primary
    }
}
