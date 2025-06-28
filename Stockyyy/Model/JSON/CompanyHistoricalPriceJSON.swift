//
//  CompanyHistoricalPriceJSON.swift
//  Stockyyy
//
//  Created by Josh R on 11/16/20.
//

import Foundation

struct CompanyHistoricalPriceJSON: Codable {
    var symbol: String
    var historical: [Historical]?

    struct Historical: Codable {
        var date: String?
        var close: Double?
    }
}
