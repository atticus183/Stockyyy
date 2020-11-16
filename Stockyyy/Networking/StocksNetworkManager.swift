//
//  StocksNetworkManager.swift
//  Stockyyy
//
//  Created by Josh R on 11/14/20.
//

//----API DOCUMENTATION----
//https://financialmodelingprep.com/developer/docs

import Foundation

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
    
    func getData(from endPoint: Endpoint, completion: @escaping (Result<[CompanyJSON], StockError>) -> Void) {
        //Check if valid URL.  If not, throw badURL error
        guard let endPointURL = URL(string: baseURL + endPoint.endpointString + "?apikey=\(apiKey)") else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: endPointURL) { (data, response, error) in
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
            jsonDecoder.dateDecodingStrategy = .formatted(CompanyJSON.dateFormatter)
            
            do {
                let decodedJSON = try jsonDecoder.decode([CompanyJSON].self, from: data)
                completion(.success(decodedJSON))
            } catch {
                print("Decode Error: \(error.localizedDescription)")
                completion(.failure(.jsonDecodeError))
            }
        }.resume()
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
            }
        }
    }
}
