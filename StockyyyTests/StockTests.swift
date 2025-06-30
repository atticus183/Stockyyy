//
//  StockTests.swift
//  StockyyyTests
//
//  Created by Josh R on 11/17/20.
//

@testable import Stockyyy
import XCTest

final class StockTests: XCTestCase {

    var sut: Stock!

    override func setUp() {
        super.setUp()

        sut = Stock(
            symbol: "AAPL",
            name: "Apple Inc",
            price: 123.45,
            exchange: "Nasdaq Global Select",
            exchangeShortName: "NASDAQ"
        )
    }

    override func tearDown() {
        super.tearDown()

        sut = nil
    }

    // Price = 123.444
    func test_Company_PriceFormatter() {
        XCTAssert(sut.priceFormatted == "$123.45")
    }
}
