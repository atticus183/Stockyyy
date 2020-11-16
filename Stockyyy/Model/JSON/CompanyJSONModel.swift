//
//  CompanyJSONModel.swift
//  Stockyyy
//
//  Created by Josh R on 11/14/20.
//

import Foundation


struct CompanyJSONModel: Codable {
    //Properties set with Symbols List endpoint
    var symbol: String?
    var name: String?
    var price: Double?
    var exchange: String?
    
    //Properties set with Company Profile endpoint
    var changes: Double?
    var currency: String?
    var website: String?
    var description: String?
    var ceo: String?
    var image: String?
    var ipoDate: Date?
}

extension CompanyJSONModel {
    //Used to convert the provided string date to a Date object when decoding.
    static var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/ddd"
        return df
    }
}
