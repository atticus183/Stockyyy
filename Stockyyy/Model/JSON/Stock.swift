import Foundation

// https://site.financialmodelingprep.com/developer/docs#symbol-list-stock-list
struct Stock: Decodable {
    let symbol: String
    let name: String?
    let price: Double?
    let exchange: String?
    let exchangeShortName: String?
}

extension Stock {
    // Used to convert the provided string date to a Date object when decoding.
    static var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        return df
    }

    var priceNumberFormatter: NumberFormatter {
        let nf = NumberFormatter()
        nf.currencyCode = "USD"
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

    // MARK: - Computed Properties

    var priceFormatted: String? {
        let nsNumber = NSNumber(value: price ?? 0.0)

        return priceNumberFormatter.string(from: nsNumber)
    }

    var priceFormattedAsDecimal: String? {
        let nsNumber = NSNumber(value: price ?? 0.0)

        return decimalFormatter.string(from: nsNumber)
    }
}

/*
 [
     {
         "symbol": "PWP",
         "exchange": "NASDAQ Global Select",
         "exchangeShortName": "NASDAQ",
         "price": "8.13",
         "name": "Perella Weinberg Partners"
     }
 ]
 */
