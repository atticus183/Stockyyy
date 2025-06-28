import UIKit

final class SplitVC: UISplitViewController {

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

// MARK: - UISplitViewControllerDelegate

extension SplitVC: UISplitViewControllerDelegate {

    func splitViewController(
        _ svc: UISplitViewController,
        topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column
    ) -> UISplitViewController.Column {
        .primary
    }
}
