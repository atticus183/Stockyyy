//
//  CompanyJSONTests.swift
//  StockyyyTests
//
//  Created by Josh R on 11/17/20.
//

import XCTest
@testable import Stockyyy

class CompanyJSONTests: XCTestCase {
    
    var sut: CompanyJSON!

    override func setUp() {
        super.setUp()
        
        sut = CompanyJSON(symbol: "AAPL", name: "Apple Inc", price: 123.45, exchange: "Nasdaq Global Select", changes: 1.234, currency: "USD", website: "www.apple.com", description: nil, ceo: "Tim Cook", image: nil, ipoDate: "1980-12-12")
    }
    
    override func tearDown() {
        super.tearDown()
        
        sut = nil
    }
    
    //MARK: Price formatter tests
    //Price = 123.444
    func test_CompanyJSON_PriceFormatter_RoundDown() {
        sut.price = 123.444
        sut.currency = "USD"
        
        XCTAssert(sut.priceFormatted == "$123.44", "The CompanyJSON priceFormatter is not rounding down properly.")
    }
    
    //Price = 123.446
    func test_CompanyJSON_PriceFormatter_RoundUp() {
        sut.price = 123.446
        sut.currency = "USD"
        
        XCTAssert(sut.priceFormatted == "$123.45", "The CompanyJSON priceFormatter is not rounding up properly.")
    }

}
