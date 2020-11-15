//
//  StocksNetworkManager.swift
//  Stockyyy
//
//  Created by Josh R on 11/14/20.
//

//----API DOCUMENTATION----
//https://financialmodelingprep.com/developer/docs

import Foundation
import RealmSwift

final class StocksNetworkManager {
    
    static let shared = StocksNetworkManager()
    private init() {}
    
    private var apiKey = FinancialModelingPrep.APIKEY
    
    //MARK: Endpoint paths
    enum Endpoint {
        case stockList
        case companyProfile(String)
        
        var endpointString: String {
            switch self {
            case .stockList:
                return "stock/list"
            case .companyProfile(let symbol):
                return "profile/\(symbol)"
            }
        }
    }
    
    private let baseURL = "https://financialmodelingprep.com/api/v3/"
    
    func getData(from endPoint: Endpoint, completion: @escaping (Result<Void, StockError>) -> Void) {
        //Check if valid URL.  If not, throw badURL error
        guard let endPointURL = URL(string: baseURL + endPoint.endpointString + "?apikey=\(apiKey)") else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: endPointURL) { [weak self] (data, response, error) in
            if let _ = error {
                completion(.failure(.requestError))
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                guard 200...299 ~= httpResponse.statusCode else {
                    completion(.failure(.httpError(httpResponse.statusCode)))
                    return
                }
            }
            
            guard let data = data else {
                completion(.failure(.dataError))
                return
            }
            
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .formatted(CompanyJSONModel.dateFormatter)
            
            do {
                let decodedJSON = try jsonDecoder.decode([CompanyJSONModel].self, from: data)
                //Save decodedJSON to Realm model
                try self?.saveToRealm(companyJSON: decodedJSON)
                completion(.success(()))
            } catch {
                print("Decode Error: \(error.localizedDescription)")
                completion(.failure(.jsonDecodeError))
            }
        }.resume()
    }
    
    private func saveToRealm(companyJSON: [CompanyJSONModel]) throws {
        guard let realm = MyRealm.getConfig() else { return }
        
        do {
            try realm.write {
                for compJson in companyJSON {
                    //Create new realm object
                    let company = Company(symbol: compJson.symbol ?? "", name: compJson.name ?? "", price: compJson.price ?? 0.0, exchange: compJson.exchange ?? "")
                    
                    //If the count is 1, then the Company Profile was retrieved.
                    if companyJSON.count == 1 {
                        company.name = compJson.name ?? ""
                        company.price = compJson.price ?? 0.0
                        company.exchange = compJson.exchange ?? ""
                        company.changes = compJson.changes ?? 0.0
                        company.currency = compJson.currency ?? ""
                        company.website = compJson.website ?? ""
                        company.companyDescription = compJson.companyDescription ?? ""
                        company.ceo = compJson.ceo ?? ""
                        company.imageURL = compJson.imageURL ?? ""
                        company.ipoDate = compJson.ipoDate
                    }
                    
                    realm.add(company)
                }
            }
        } catch {
            throw StockError.saveToRealmError
        }
    }
}

//MARK: Custom error type
extension StocksNetworkManager {
    enum StockError: Error {
        case invalidURL
        case httpError(Int)
        case requestError
        case dataError
        case jsonDecodeError
        case saveToRealmError
        
        var errorDescription: String {
            switch self {
            case .invalidURL:
                return "The endpoint URL provided is invalid."
            case .httpError(let statusCode):
                return "There was an error retrieving the data.  Error code \(statusCode)"
            case .requestError:
                return "There was an error with the request to the network."
            case .dataError:
                return "There was an error with the data retrieved from the endpoint."
            case .jsonDecodeError:
                return "JSON decode error."
            case .saveToRealmError:
                return "There was an issue saving the JSON to the user's realm."
            }
        }
    }
}
