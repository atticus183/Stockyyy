import UIKit

final class StocksDatasource: NSObject {

    // MARK: - Properties

    private var allCompanies: [CompanyJSON]
    private var filteredCompanies = [CompanyJSON]()

    var numberOfCompaniesInDatasource: Int {
        isSearching ? filteredCompanies.count : allCompanies.count
    }

    private var isSearching = false

    // MARK: - Initialization

    init(companies: [CompanyJSON]) {
        allCompanies = companies.sorted(by: { $0.symbol < $1.symbol })
    }

    // MARK: - Methods

    func company(at indexPath: IndexPath) -> CompanyJSON? {
        isSearching ? filteredCompanies[indexPath.row] : allCompanies[indexPath.row]
    }

    func searchForCompany(with searchText: String) {
        isSearching = searchText.isEmpty ? false : true

        if isSearching {
            filteredCompanies = allCompanies.filter { company -> Bool in
                let exchange = company.exchange ?? ""
                let name = company.name ?? ""

                let isFound = company.symbol.lowercased().contains(searchText.lowercased())
                    || exchange.lowercased().contains(searchText.lowercased())
                    || name.lowercased().contains(searchText.lowercased())

                return isFound
            }
        } else {
            filteredCompanies.removeAll()
        }
    }
}

// MARK: - UITableViewDataSource

extension StocksDatasource: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numberOfCompaniesInDatasource
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StockCell.identifier, for: indexPath) as? StockCell else { return UITableViewCell() }

        let company = isSearching ? filteredCompanies[indexPath.row] : allCompanies[indexPath.row]
        cell.company = company

        return cell
    }
}
