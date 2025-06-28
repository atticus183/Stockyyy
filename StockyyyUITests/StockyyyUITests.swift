//
//  StockyyyUITests.swift
//  StockyyyUITests
//
//  Created by Josh R on 11/13/20.
//

import XCTest
// @testable import Stockyyy

class StockyyyUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        super.setUp()

        continueAfterFailure = false

        app = XCUIApplication()
        app.launch()
    }

    override func tearDown() {
        super.tearDown()
        app = nil
    }

    func test_chart_isVisible() {
        // NOTE - not working at this time 11/18/2020
//        app.tables["StocksListVC_Table"].cells.element(boundBy: 0).tap()
    }

    func test_changesLbl_is_red() {}

    func test_changesLbl_is_green() {}
}
