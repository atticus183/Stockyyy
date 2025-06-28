//
//  ExtensionTests.swift
//  StockyyyTests
//
//  Created by Josh R on 11/17/20.
//

@testable import Stockyyy
import XCTest

class ExtensionTests: XCTestCase {

    var sut: [Date]!

    override func setUp() {
        super.setUp()

        sut = []
    }

    override func tearDown() {
        super.tearDown()

        sut = nil
    }

    func test_date_numberOf_method_OneDay() {
        let date1 = DateComponents(calendar: .current, year: 2020, month: 12, day: 1).date!
        let date2 = DateComponents(calendar: .current, year: 2020, month: 12, day: 2).date!

        sut = [
            date1,
            date2
        ]

        let numberOfDays = Date.numberOf(.day, from: sut[0], to: sut[1])
        XCTAssert(numberOfDays == 1, "The Date type method numberOf did not calculate the number of days correctly.")
    }

    func test_date_numberOf_method_OneMonth() {
        let date1 = DateComponents(calendar: .current, year: 2020, month: 10, day: 1).date!
        let date2 = DateComponents(calendar: .current, year: 2020, month: 12, day: 1).date!

        sut = [
            date1,
            date2
        ]

        let numberOfMonths = Date.numberOf(.month, from: sut[0], to: sut[1])
        XCTAssert(numberOfMonths == 2, "The Date type method numberOf did not calculate the number of months correctly.")
    }

    func test_date_numberOf_method_OneYear() {
        let date1 = DateComponents(calendar: .current, year: 2019, month: 12, day: 1).date!
        let date2 = DateComponents(calendar: .current, year: 2020, month: 12, day: 1).date!

        sut = [
            date1,
            date2
        ]

        let numberOfYears = Date.numberOf(.year, from: sut[0], to: sut[1])
        XCTAssert(numberOfYears == 1, "The Date type method numberOf did not calculate the number of years correctly.")
    }
}
