//
//  LabelViewWithDescription.swift
//  Stockyyy
//
//  Created by Josh R on 11/18/20.
//

import UIKit

final class LabelViewWithDescription: UIView {

    // MARK: - Properties

    lazy var primaryLbl: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()

    lazy var descriptionLbl: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.sizeToFit()

        return label
    }()

    let lblStackView: UIStackView = {
       let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .center
        sv.distribution = .fill

        return sv
    }()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }

    // NOTE - implementation not needed. Not using SBs
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    private func setupViews() {
        lblStackView.addArrangedSubview(primaryLbl)
        lblStackView.addArrangedSubview(descriptionLbl)

        addSubview(lblStackView)

        lblStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            lblStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            lblStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            lblStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 0),
            lblStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0)
        ])
    }
}
