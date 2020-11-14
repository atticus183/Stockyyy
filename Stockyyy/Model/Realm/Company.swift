//
//  Company.swift
//  Stockyyy
//
//  Created by Josh R on 11/13/20.
//

import Foundation
import RealmSwift

class Company: Object {
    //Properties for Symbol List endpoint
    @objc dynamic var symbol: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var price: Double = 0.0
    @objc dynamic var exchange: String = ""
    
    //Properties for Company Profile endpoint
    @objc dynamic var changes: Double = 0.0
    @objc dynamic var currency: String = "USD"
    @objc dynamic var website: String = ""
    @objc dynamic var companyDescription: String = ""
    @objc dynamic var ceo: String = ""
    @objc dynamic var imageURL: String = ""
    @objc dynamic var ipoDate: Date? = nil
    
    //Unique ID
    @objc dynamic var id = UUID().uuidString
    override static func primaryKey() -> String? {
        return "id"
    }
    
    //Convenience Init to assist creation when retrieving all symbols.  Company details will be added when the user taps on the desired stock cell.
    convenience init(symbol: String, name: String, price: Double, exchange: String) {
        self.init()
        self.symbol = symbol
        self.name = name
        self.price = price
        self.exchange = exchange
    }
    
}

extension Company {
    //MARK: Formatters
    var priceNumberFormatter: NumberFormatter {
        let nf = NumberFormatter()
        nf.currencyCode = self.currency
        nf.numberStyle = .currency
        
        return nf
    }
    
    var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "MMMM d yyyy"
        
        return df
    }
    
    //MARK: Computed Properties
    var priceFormatter: String? {
        let nsNumber = NSNumber(value: self.price)
        
        return priceNumberFormatter.string(from: nsNumber)
    }
    
    var ipoDateFormatter: String? {
        guard let ipoDate = self.ipoDate else { return "" }
        
        return dateFormatter.string(from: ipoDate)
    }
}