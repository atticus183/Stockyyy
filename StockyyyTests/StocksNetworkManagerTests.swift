//
//  StocksNetworkManagerTests.swift
//  StockyyyTests
//
//  Created by Josh R on 11/17/20.
//

import XCTest
@testable import Stockyyy

class StocksNetworkManagerTests: XCTestCase {
    
    var sut: StocksNetworkManager!
    
    override func setUp() {
        super.setUp()
        
        sut = StocksNetworkManager()
    }
    
    override func tearDown() {
        super.tearDown()
        
        sut = nil
    }
    
    func test_stockList_endpoint() {
        let promise = expectation(description: "Data downloaded for the stockList endpoint")
        
        sut.getData(for: CompanyJSON.self, from: .stockList) { (result) in
            switch result {
            case .success(let companyJSON):
                if companyJSON.count > 0 {
                    promise.fulfill()
                }
            case .failure:
                break
            }
        }
        
        wait(for: [promise], timeout: 5)
    }
    
    func test_companyProfile_endpoint() {
        let symbolToGet = "AAPL"
        let promise = expectation(description: "Data downloaded for the companyProfile endpoint")
        
        sut.getData(for: CompanyJSON.self, from: .companyProfile(symbolToGet)) { (result) in
            switch result {
            case .success(let companyJSON):
                if companyJSON.first?.symbol == symbolToGet {
                    promise.fulfill()
                }
            case .failure:
                break
            }
        }
        
        wait(for: [promise], timeout: 5)
    }
    
    func test_historicalPrices_endpoint() {
        let appleSymbol = "AAPL"
        let promise = expectation(description: "Data downloaded for the historicalPrices endpoint")
        
        sut.getData(for: CompanyHistoricalPriceJSON.self, from: .historicalPrices(appleSymbol)) { (result) in
            switch result {
            case .success(let companyHistoricalPrices):
                if let company = companyHistoricalPrices.first, let historicalPrices = company.historical {
                    if company.symbol == appleSymbol && historicalPrices.count > 0 {
                        promise.fulfill()
                    }
                }
            case .failure:
                break
            }
        }
        
        wait(for: [promise], timeout: 5)
    }
    
}
