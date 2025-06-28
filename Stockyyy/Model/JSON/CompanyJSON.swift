import Foundation

struct CompanyJSON: Codable {
    // Properties set with Symbols List endpoint
    var symbol: String
    var name: String?
    var price: Double?
    var exchange: String?

    // Properties set with Company Profile endpoint
    var changes: Double?
    var currency: String?
    var website: String?
    var description: String?
    var ceo: String?
    var image: String?
    var ipoDate: String? // some companies are formatted yyyy/MM/ddd, some MM/dd/YY.
}

extension CompanyJSON {
    // Used to convert the provided string date to a Date object when decoding.
    static var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        return df
    }

    // MARK: Formatters

    var priceNumberFormatter: NumberFormatter {
        let nf = NumberFormatter()
        nf.currencyCode = self.currency
        nf.numberStyle = .currency

        return nf
    }

    // The Symbols List endpoint doesn't provide the currency code.
    var decimalFormatter: NumberFormatter {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.maximumFractionDigits = 2
        nf.minimumFractionDigits = 2

        return nf
    }

    var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "MMMM d yyyy"

        return df
    }

    // MARK: Computed Properties

    var priceFormatted: String? {
        let nsNumber = NSNumber(value: self.price ?? 0.0)

        return priceNumberFormatter.string(from: nsNumber)
    }

    var priceFormattedAsDecimal: String? {
        let nsNumber = NSNumber(value: self.price ?? 0.0)

        return decimalFormatter.string(from: nsNumber)
    }

    var changesFormatted: String? {
        let nsNumber = NSNumber(value: self.changes ?? 0.0)

        return priceNumberFormatter.string(from: nsNumber)
    }
}
