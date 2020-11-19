# Stockyyy
![Stockyyy Portfolio](https://user-images.githubusercontent.com/25728996/99630902-415e5580-2a00-11eb-8981-65871fa4baee.png)

An app to view daily stock prices and get more information about the different companies.  

## Details
- 100% programmatic, no storyboards
- Available for iPhone and iPad
- The `StocksNetworkManager` class utilizes a generic method to retrieve and parse JSON using the `Codable` protocol
- Utilizes the [Financial Modeling Prep](https://financialmodelingprep.com/developer/docs) API to retrieve updated stock prices, historical prices, price change, and company description
- Swift Package Manager to manage library dependencies
- Uses the [Charts](https://github.com/danielgindi/Charts) library to build a graph to display historical prices
- Uses the [Kingfisher](https://github.com/onevcat/Kingfisher) library to retrieve and cache the company logo
- Contains several Unit Tests to test the functionality of the CompanyJSON type, custom extensions, StocksDatasource class, and the StocksManager class
- Ability to search for the company Ticker Symbol, company full name, and/or the exchange.
