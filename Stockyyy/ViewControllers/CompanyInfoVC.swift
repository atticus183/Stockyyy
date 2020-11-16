//
//  CompanyInfoVC.swift
//  Stockyyy
//
//  Created by Josh R on 11/13/20.
//

import RealmSwift
import UIKit

final class CompanyInfoVC: UIViewController {
    
    var realm: Realm?
    
//    var passedCompanyID: String? {
//        didSet {
//            guard let retrievedCompany = realm?.objects(Company.self).filter("id == %d", passedCompanyID ?? "").first else { return }
//            passedCompany = retrievedCompany
//        }
//    }
//
    var passedCompany: Company? {
        didSet {
            companytitleView.company = passedCompany
        }
    }
    
    lazy var companytitleView = CompanyDetailTitleView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        realm = MyRealm.getConfig()
        
        self.navigationItem.titleView = companytitleView
        self.view.backgroundColor = .systemBackground
    }

}

extension CompanyInfoVC: StocksListVCDelegate {
    func stockTapped(_ company: Company) {
        passedCompany = company
    }
}
