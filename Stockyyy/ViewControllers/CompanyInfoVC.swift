//
//  CompanyInfoVC.swift
//  Stockyyy
//
//  Created by Josh R on 11/13/20.
//

import UIKit

final class CompanyInfoVC: UIViewController {
    
    var passedCompany: CompanyJSON? {
        didSet {
            companytitleView.company = passedCompany
        }
    }
    
    lazy var companytitleView = CompanyDetailTitleView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = companytitleView
        self.view.backgroundColor = .systemBackground
    }
    
}

extension CompanyInfoVC: StocksListVCDelegate {
    func tickerTapped(_ company: CompanyJSON) {
        passedCompany = company
    }
}
