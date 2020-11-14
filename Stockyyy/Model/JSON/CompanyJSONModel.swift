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
    var companyDescription: String?
    var ceo: String?
    var imageURL: String?
    var ipoDate: Date?
}
