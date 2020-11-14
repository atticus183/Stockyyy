//
//  StockCell.swift
//  Stockyyy
//
//  Created by Josh R on 11/13/20.
//

import UIKit

final class StockCell: UITableViewCell {
    
    static let identifier = "StockCell"
    
    var company: Company? {
        didSet {
            guard let company = company else { return }
            symbolLbl.text = company.symbol
            companyNameLbl.text = company.name
            exchangeLbl.text = company.exchange
            currentPriceLbl.text = company.priceFormatted
        }
    }
    
    //MARK: Labels
    //Symbol lbl
    lazy var symbolLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 1
        label.textAlignment = .left
        label.sizeToFit()
        
        return label
    }()
    
    //Full company name lbl
    lazy var companyNameLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        label.numberOfLines = 1
        label.sizeToFit()
        
        return label
    }()
    
    //Exchange lbl
    lazy var exchangeLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .darkGray
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.8
        label.textAlignment = .left
        label.sizeToFit()
        
        return label
    }()
    
    lazy var currentPriceLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 1
        label.textAlignment = .left
        label.sizeToFit()
        
        return label
    }()
    
    //MARK: Stack Views
    //SV for symbol, company name, and exchange
    let companyInfoVSV: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .leading
        
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = .systemGray6
        
        addSubViews(views: companyInfoVSV, currentPriceLbl)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        //NOTE: Setup not needed.  Not using SB.
    }
    
    private func addViewsToStackView() {
        companyInfoVSV.addArrangedSubview(symbolLbl)
        companyInfoVSV.addArrangedSubview(companyNameLbl)
        companyInfoVSV.addArrangedSubview(exchangeLbl)
    }
    
    private func addSubViews(views: UIView...) {
        addViewsToStackView()
        views.forEach({ self.contentView.addSubview($0) })
        views.forEach({ $0.translatesAutoresizingMaskIntoConstraints = false })
        setViewConstaints()
    }
    
    private func setViewConstaints() {
        //Note - translatesAutoresizingMaskIntoConstraints set to false in addSubViews method
        NSLayoutConstraint.activate([
            companyInfoVSV.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
            companyInfoVSV.trailingAnchor.constraint(equalTo: self.currentPriceLbl.leadingAnchor, constant: -2),
            companyInfoVSV.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -3),
            companyInfoVSV.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 3),
            
            currentPriceLbl.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8),
            currentPriceLbl.widthAnchor.constraint(lessThanOrEqualToConstant: 175),
            currentPriceLbl.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }
    
}
