//
//  CompanyInfoVC.swift
//  Stockyyy
//
//  Created by Josh R on 11/13/20.
//

import UIKit

final class CompanyInfoVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
    }

}

extension CompanyInfoVC: StocksListVCDelegate {
    func stockTapped(_ stock: String) {
        //TODO:
    }
}
