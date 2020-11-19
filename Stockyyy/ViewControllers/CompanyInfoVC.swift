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
            guard let passedCompany = passedCompany else { return }
            companytitleView.company = passedCompany
            currentPriceLabelView.primaryLbl.text = passedCompany.priceFormatted
            priceChangeLabelView.primaryLbl.text = passedCompany.changesFormatted
            priceChangeLabelView.primaryLbl.textColor = passedCompany.changes ?? 0.0 < 0 ? .systemRed : .systemGreen
            companyDescriptionLbl.text = passedCompany.description ?? "Company description not available."
            
            stocksNetworkManager.getData(for: CompanyHistoricalPriceJSON.self, from: .historicalPrices(passedCompany.symbol)) { [weak self] (result) in
                switch result {
                case .success(let prices):
                    DispatchQueue.main.async {
                        self?.historicalPrices = prices.first
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }
    
    var historicalPrices: CompanyHistoricalPriceJSON? {
        didSet { historicalPriceGraphView.historicalPrices = historicalPrices }
    }
    
    lazy var stocksNetworkManager = StocksNetworkManager()
    
    lazy var companytitleView = CompanyDetailTitleView()
    lazy var historicalPriceGraphView = HistoricalPriceGraphView()
    
    
    lazy var currentPriceLabelView: LabelViewWithDescription = {
        let labelView = LabelViewWithDescription()
        labelView.primaryLbl.textColor = .systemGreen
        labelView.primaryLbl.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        labelView.descriptionLbl.text = "Current Price"
        return labelView
    }()
    
    lazy var priceChangeLabelView: LabelViewWithDescription = {
        let labelView = LabelViewWithDescription()
        //font color set in passedCompany observer
        labelView.primaryLbl.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        labelView.descriptionLbl.text = "Price Change"
        return labelView
    }()
    
    lazy var companyDescriptionLbl: UITextView = {
        let textView = UITextView()
        textView.textColor = .label
        textView.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        textView.textAlignment = .left
        textView.isEditable = false
        textView.sizeToFit()
        
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView = companytitleView
        self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        self.view.backgroundColor = .systemBackground
        
        addSubviews(views: historicalPriceGraphView, priceChangeLabelView, currentPriceLabelView ,companyDescriptionLbl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
          
    }
    
    private func addSubviews(views: UIView...) {
        views.forEach({
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        setViewConstraints()
    }
    
    private func setViewConstraints() {
        NSLayoutConstraint.activate([
            historicalPriceGraphView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            historicalPriceGraphView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            historicalPriceGraphView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 5),
            historicalPriceGraphView.heightAnchor.constraint(equalToConstant: 200),

            priceChangeLabelView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            priceChangeLabelView.topAnchor.constraint(equalTo: self.historicalPriceGraphView.bottomAnchor, constant: 5),
            
            currentPriceLabelView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            currentPriceLabelView.topAnchor.constraint(equalTo: self.historicalPriceGraphView.bottomAnchor, constant: 5),
            
            companyDescriptionLbl.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            companyDescriptionLbl.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            companyDescriptionLbl.topAnchor.constraint(equalTo: self.priceChangeLabelView.bottomAnchor, constant: 8),
            companyDescriptionLbl.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -5)
        ])
    }
    
}

extension CompanyInfoVC: StocksListVCDelegate {
    func tickerTapped(_ company: CompanyJSON) {
        passedCompany = company
    }
}
