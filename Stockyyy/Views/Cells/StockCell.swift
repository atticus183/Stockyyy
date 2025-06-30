//
//  StockCell.swift
//  Stockyyy
//
//  Created by Josh R on 11/13/20.
//

import UIKit

final class StockCell: UITableViewCell {

    // MARK: - Properties

    var company: Stock? {
        didSet {
            guard let company else { return }
            symbolLbl.text = company.symbol
            companyNameLbl.text = company.name
            exchangeLbl.text = company.exchange
            currentPriceLbl.text = company.priceFormattedAsDecimal // The Symbols List endpoint doesn't provide the currency code.
        }
    }

    lazy var symbolLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 1
        label.textAlignment = .left
        label.sizeToFit()

        return label
    }()

    lazy var companyNameLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .label
        label.numberOfLines = 1
        label.sizeToFit()

        return label
    }()

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

    // SV for symbol, company name, and exchange
    let companyInfoVSV: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .leading

        return stackView
    }()

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.backgroundColor = .systemGray6

        addSubViews(views: companyInfoVSV, currentPriceLbl)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    private func addViewsToStackView() {
        companyInfoVSV.addArrangedSubview(symbolLbl)
        companyInfoVSV.addArrangedSubview(companyNameLbl)
        companyInfoVSV.addArrangedSubview(exchangeLbl)
    }

    private func addSubViews(views: UIView...) {
        addViewsToStackView()
        views.forEach { self.contentView.addSubview($0) }
        views.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        setViewConstraints()
    }

    private func setViewConstraints() {
        NSLayoutConstraint.activate([
            companyInfoVSV.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            companyInfoVSV.trailingAnchor.constraint(equalTo: currentPriceLbl.leadingAnchor, constant: -2),
            companyInfoVSV.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3),
            companyInfoVSV.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3),

            currentPriceLbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            currentPriceLbl.widthAnchor.constraint(lessThanOrEqualToConstant: 175),
            currentPriceLbl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
