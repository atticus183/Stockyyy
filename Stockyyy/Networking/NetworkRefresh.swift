import Foundation

//Note - separated this from the StocksNetworkManager class to make it easier to test
//Note - not using right now 11/15/2020
struct NetworkRefresh {
    typealias UDKey = String
    private let userDefaults = UserDefaults.standard
    
    private let udKey: UDKey
    
    init(with udKey: UDKey)  {
        self.udKey = udKey
    }
    
    func save(refresh date: Date) {
        userDefaults.set(date, forKey: UDKeys.stockSymbolRefreshDate)
    }
    
    private var lastRefreshDate: Date {
        guard let refreshDate = userDefaults.object(forKey: udKey) as? Date else {
            let initialDate = Date(timeIntervalSince1970: 0)
            return initialDate
        }
        return refreshDate
    }
    
    var isRefreshNeeded: Bool {
        let dateDifference = Date.numberOf(.day, from: lastRefreshDate, to: Date()) ?? 0
        return dateDifference > 0 ? true : false
    }

}
