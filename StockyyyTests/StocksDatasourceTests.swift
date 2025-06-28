//
//  StocksDatasourceTests.swift
//  StockyyyTests
//
//  Created by Josh R on 11/17/20.
//

@testable import Stockyyy
import XCTest

class StocksDatasourceTests: XCTestCase {

    var sut: StocksDatasource!

    override func setUp() {
        super.setUp()

        let company1 = CompanyJSON(symbol: "AAPL", name: "Apple", price: 123.45, currency: "USD", ceo: "Tim Cook")
        let company2 = CompanyJSON(symbol: "MSFT", name: "Microsoft", price: 216.59, currency: "USD", ceo: "Satya Nadella")
        let company3 = CompanyJSON(symbol: "GOOGL", name: "Alphabet Inc", price: 1766.85, currency: "USD", ceo: "Sundar Pichai")

        sut = StocksDatasource(companies: [company1, company2, company3])
    }

    override func tearDown() {
        super.tearDown()

        sut = nil
    }

    func test_datasource_is_not_nil() {
        XCTAssertNotNil(sut, "The dataSource is nil.")
    }

    func test_datasource_contains_3_companies() {
        XCTAssert(sut.numberOfCompaniesInDatasource == 3, "The datasource contains the wrong number of companies.")
    }

    func test_search_for_apple() {
        sut.searchForCompany(with: "AAPL")
        XCTAssert(sut.numberOfCompaniesInDatasource == 1, "There is a duplicate symbol in the datasource.")
    }

    func test_company_at_indexPath() {
        let desiredIndexPath = IndexPath(row: 1, section: 0)

        // NOTE - the StocksDatasource init sorts the companies from A-Z.
        let selectedCompany = sut.company(at: desiredIndexPath)!

        XCTAssert(selectedCompany.symbol == "GOOGL", "The companyAt indexPath method did not retrieve the correct item.")
    }
}
