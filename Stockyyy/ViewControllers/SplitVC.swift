import UIKit

final class SplitVC: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        preferredDisplayMode = .oneBesideSecondary

        let stocksListVC = StocksListVC()
        let companyInfoVC = CompanyInfoVC()

        stocksListVC.delegate = companyInfoVC

        setViewController(stocksListVC, for: .primary)
        setViewController(companyInfoVC, for: .secondary)
    }
}

// MARK: - UISplitViewControllerDelegate

extension SplitVC: UISplitViewControllerDelegate {

    func splitViewController(
        _ svc: UISplitViewController,
        topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column
    ) -> UISplitViewController.Column {
        .primary
    }
}
