import UIKit

final class CompanyInfoVC: UIViewController {

    // MARK: - Properties

    var profile: CompanyProfile? {
        didSet {
            guard let profile else { return }

            companyTitleView.profile = profile
            currentPriceLabelView.primaryLbl.text = profile.priceFormatted
            priceChangeLabelView.primaryLbl.text = profile.changesFormatted
            priceChangeLabelView.primaryLbl.textColor = profile.changes ?? 0.0 < 0 ? .systemRed : .systemGreen
            companyDescriptionLbl.text = profile.description ?? "Company description not available."

            stocksNetworkManager.getData(for: HistoricalPrice.self, from: .historicalPrices(profile.symbol)) { [weak self] result in
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

    private var historicalPrices: HistoricalPrice? {
        didSet { historicalPriceGraphView.historicalPrices = historicalPrices }
    }

    private lazy var stocksNetworkManager = StocksNetworkManager()

    private lazy var companyTitleView = CompanyDetailTitleView()
    private lazy var historicalPriceGraphView = HistoricalPriceGraphView()

    lazy var currentPriceLabelView: LabelViewWithDescription = {
        let labelView = LabelViewWithDescription()
        labelView.primaryLbl.textColor = .systemGreen
        labelView.primaryLbl.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        labelView.descriptionLbl.text = "Current Price"
        return labelView
    }()

    private lazy var priceChangeLabelView: LabelViewWithDescription = {
        let labelView = LabelViewWithDescription()
        // font color set in passedCompany observer
        labelView.primaryLbl.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        labelView.descriptionLbl.text = "Price Change"
        return labelView
    }()

    private lazy var companyDescriptionLbl: UITextView = {
        let textView = UITextView()
        textView.textColor = .label
        textView.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        textView.textAlignment = .left
        textView.isEditable = false
        textView.sizeToFit()

        return textView
    }()

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.titleView = companyTitleView
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .systemBackground

        addSubviews(
            views: historicalPriceGraphView,
            priceChangeLabelView,
            currentPriceLabelView,
            companyDescriptionLbl
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: - Methods

    private func addSubviews(views: UIView...) {
        views.forEach {
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        setViewConstraints()
    }

    private func setViewConstraints() {
        NSLayoutConstraint.activate([
            historicalPriceGraphView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            historicalPriceGraphView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            historicalPriceGraphView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            historicalPriceGraphView.heightAnchor.constraint(equalToConstant: 200),

            priceChangeLabelView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            priceChangeLabelView.topAnchor.constraint(equalTo: historicalPriceGraphView.bottomAnchor, constant: 5),

            currentPriceLabelView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            currentPriceLabelView.topAnchor.constraint(equalTo: historicalPriceGraphView.bottomAnchor, constant: 5),

            companyDescriptionLbl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            companyDescriptionLbl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            companyDescriptionLbl.topAnchor.constraint(equalTo: priceChangeLabelView.bottomAnchor, constant: 8),
            companyDescriptionLbl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5)
        ])
    }
}

// MARK: - StocksListVCDelegate

extension CompanyInfoVC: StocksListVCDelegate {
    func tickerTapped(_ companyProfile: CompanyProfile) {
        profile = companyProfile
    }
}
