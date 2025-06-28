//
//  CompanyHistoricalPriceJSON.swift
//  Stockyyy
//
//  Created by Josh R on 11/16/20.
//

import Foundation

struct CompanyHistoricalPriceJSON: Codable {
    let symbol: String
    let historical: [Historical]?

    struct Historical: Codable {
        let date: String?
        let close: Double?
    }
}
