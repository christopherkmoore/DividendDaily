//
//  IEXApiClient.swift
//  DividendDaily
//
//  Created by Christopher Moore on 7/8/18.
//  Copyright © 2018 Christopher Moore. All rights reserved.
//

import Foundation

class IEXApiClient {
    
    public enum IEXError: Error {
        case missingParentObject
        
        public var localizedDescription: String {
            switch self {
            case .missingParentObject: return "Unable to parse out parent object from JSON"
            }
        }
    }
    
    public enum Endpoints: String {
        case stock = "stock/"
        case batch = "batch?"
        case types = "types="
        case dividends = "dividends/"
        case symbols = "symbols="
    }
    
    public enum Requests {
        case dividends
        case quotes
    }
    
    public enum Duration: String {
        case m1 = "1m"
        case m3 = "3m"
        case m6 = "6m"
        case ytd = "ytd"
        case y1 = "1y"
        case y2 = "2y"
        case y5 = "5y"
    }
    
    public enum Types: String {
    
        case quote = "quote,"
        case news = "news,"
        case chart = "chart,"
    }
    
    public static let shared = IEXApiClient()
    public let session = URLSession.shared
    public static let baseUrl = "https://api.iextrading.com/1.0/"
    
    private init() {}
    
    public func getDividend(for stock: String, completion: @escaping (Bool, Dividend?) -> Void) {
        
        guard let request = buildURL(for: stock, with: nil, and: .dividends) else { return }
        
        session.dataTask(with: request) { [weak self] (data, response, error) in
            guard let result = self?.getResults(data, response, error) else {
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                return
            }
            
            var dividend: Dividend?
            
            do {
                //TODO: unwrap + refactor entire project.
                dividend = try JSONDecoder().decode(Dividend.self, from: data!)
            } catch let error {
                print(error.localizedDescription)
                completion(false, nil)
            }
            
            completion(true, dividend)
        }.resume()
        
    }
    
    public func getStock(_ stock: String, completion: @escaping (Bool, Quote?) -> Void) {
        
        guard let request = buildURL(for: stock, with: nil, and: .quotes) else { return }
        
        session.dataTask(with: request) { [weak self] (data, request, error) in
            guard let data = data else { return }
            
            guard let result = self?.getResults(data, request, error) else {
                if let error = error {
                    print(error.localizedDescription)
                    completion(false, nil)
                }
                completion(false, nil)
                return
            }
            
            let dict = result as! [String: Any]
            guard let shavedParentDictionary = dict["quote"] else {
                print("\(IEXError.missingParentObject.localizedDescription) for  \(dict)")
                completion(false, nil)
                return
            }
            
            var quote: Quote?

            do {
                let backToData = try JSONSerialization.data(withJSONObject: shavedParentDictionary)
                quote = try JSONDecoder().decode(Quote.self, from: backToData)

            } catch let error {
                print(error.localizedDescription)
                completion(false, nil)
            }
            
            completion(true, quote)
        }.resume()
    }
    
    private func buildURL(for stocks: String, with types: Types?, and requests: Requests?) -> URLRequest? {
        var url = IEXApiClient.baseUrl + Endpoints.stock.rawValue

        // hacked for single stock (dividend)
//        stocks.forEach { stock in
//            if stock == stocks[stocks.count - 1].name {
//                url += stock + "/"
//                
//            } else {
//                url += stock + ", "
//            }
//        }
        url += stocks + "/"
        
        if let request = requests {
            switch request {
            case .dividends:
                url += Endpoints.dividends.rawValue + Duration.y5.rawValue
            case .quotes:
                url += Endpoints.batch.rawValue + Endpoints.types.rawValue + Types.quote.rawValue
            }
        } else {
            // assume we want stocks
            url += Endpoints.batch.rawValue + Endpoints.types.rawValue
            if let types = types {
                url += types.rawValue
            }
        }
        
        guard let realURL = URL(string: url) else { return nil }
        
        return URLRequest(url: realURL)

    }
    
    private func getResults(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> AnyObject? {
        guard let data = data else { return nil }
        
        var result: AnyObject?
        
        do {
            result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch let error {
            print(error.localizedDescription)
        }
        
        return result
    }
    
    
}
