//
//  IEXApiClient.swift
//  DividendDaily
//
//  Created by Christopher Moore on 7/8/18.
//  Copyright © 2018 Christopher Moore. All rights reserved.
//

import Foundation
import Kanna

class IEXApiClient {
    
    public enum IEXError: Error {
        case missingParentObject
        case failedScrape
        case stockNameEmpty
        
        public var localizedDescription: String {
            switch self {
            case .missingParentObject: return "Unable to parse out parent object from JSON"
            case .failedScrape: return "Your dumbass scraper is a piece of shit"
            case .stockNameEmpty: return "Search is failing with empty stock name"
            }
        }
    }
    
    public enum Endpoints: String {
        case stock = "stock/"
        case batch = "batch?"
        case types = "types="
        case dividends = "dividends/"
        case symbols = "symbols="
        case market = "market/"
        case chartInterval = "chartInterval="
        case range = "&range="
    }
    
    public enum Requests {
        case dividends
        case quotes
        case chart
    }
    
    public enum Duration: String {
        case m1 = "1m"
        case m3 = "3m"
        case m6 = "6m"
        case ytd = "ytd"
        case y1 = "1y"
        case y2 = "2y"
        case y5 = "5y"
        case marketMonthInDays = "24"
    }
    
    public enum Types: String {
    
        case quote = "quote,"
        case news = "news,"
        case chart = "chart?"
    }
    
    public static let shared = IEXApiClient()
    public let session = URLSession.shared
    public static let baseUrl = "https://api.iextrading.com/1.0/"
    
    private init() {}
    
    
    /* Probably best to stay away from this func for the time being. See note in Extension below
    public func getDividend(for stock: String, completion: @escaping (Bool, [Dividend]?) -> Void) {
        
        guard let request = buildURL(for: stock, with: nil, and: .dividends) else { return }
        
        session.dataTask(with: request) { [weak self] (data, response, error) in
            guard let result = self?.getResults(data, response, error) else {
                if let error = error {
                    print(error.localizedDescription)
                    return
     }    pod 'Alamofire', '~> 4.0'
     pod 'Kanna', '~> 2.0.0'
     end
            }
            
            var dividend: [Dividend]?
            
            do {
                //TODO: unwrap + refactor entire project.
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.yyyyMMdd)
                dividend = try decoder.decode([Dividend].self, from: data!)
            } catch let error {
                print(error.localizedDescription)
                completion(false, nil)
            }
            
            completion(true, dividend)
        }.resume()
        
    }
    */
    
    public func getChartData(for stock: Stock, completion: @escaping (Bool, Stock?) -> Void) {
        
        // ex URL https://api.iextrading.com/1.0/stock/aapl/chart?chartInterval=24&range=1y
        guard let request = buildURL(for: stock.ticker, with: nil, and: .chart) else { return }
        
        session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                print(error?.localizedDescription as Any)
                completion(false, nil)
                return
            }
            
            var chartPoints: [ChartPoint]
            
            do {
                chartPoints = try JSONDecoder().decode(Array<ChartPoint>.self, from: data)
                let set = NSOrderedSet(array: chartPoints)
                stock.chartPoints = set
            } catch let error {
                print(error.localizedDescription)
                completion(false, nil)
            }
            completion(true, stock)
            
        }.resume()
        
    }
    
    
    /* TODO: probably a good idea to submit a batch request */
    public func refreshQuote(for stocks: [Stock], completion: @escaping (Bool, [Stock]?) -> Void) {
        guard let request = buildBatchURL(for: stocks) else { return }
        
        session.dataTask(with: request) {[stocks] (data, response, error) in
            
            guard let data = data else {
//                print(error?.localizedDescription ?? "Error finding stock info for \(stock.ticker)")
                return
            }

            guard let result = self.getResults(data, response, error) else { return }
            
            
            /* this is garbage code and needs debugging */
            result.forEach { (key, value) in
                
                let something = stocks.map { ( stock) -> Stock in
                    if stock.ticker == key {
                        do {
                            let data: Data = try JSONSerialization.data(withJSONObject: value, options: JSONSerialization.WritingOptions.prettyPrinted)
                            stock.quote = try JSONDecoder().decode(Quote.self, from: data)
                        } catch let error {
                            print(error.localizedDescription)
                        }
                    }
                    return stock
                }
                completion(true, something)
            }
        }.resume()
    }
    
    public func getStock(_ ticker: String, completion: @escaping (Bool, Stock?) -> Void) {
        let dispatch = DispatchGroup()
        dispatch.enter()
        
        defer {
            dispatch.leave()
            completion(false, nil)
        }
        
        guard let request = buildURL(for: ticker, with: nil, and: .quotes) else { return }
        session.dataTask(with: request) { [weak self] (data, request, error) in
            
            guard let data = data else {
                print(error?.localizedDescription ?? "Error finding stock info for \(ticker)")
                return
            }
            
            var quote: Quote?

            do {
                quote = try JSONDecoder().decode(Quote.self, from: data)

            } catch let error {
                print(error.localizedDescription)
                return
            }
            
            self?.scrapeDividends(ticker) { (dividend, error) in
                dispatch.enter()
                
                if let dividend = dividend {
                    let set = NSOrderedSet(array: dividend)
                    let stock = try! Stock(ticker: ticker, quote: quote, dividend: set)
                    dispatch.leave()
                    completion(true, stock)
                    // maybe dividend doesn't exist
                } else {
                    let stock = try! Stock(ticker: ticker, quote: quote, dividend: nil)
                    completion(true, stock)
                }
            }
        }.resume()
    }
    
    private func buildBatchURL( for stocks: [Stock]) -> URLRequest? {
        var urlString = IEXApiClient.baseUrl + Endpoints.stock.rawValue + Endpoints.market.rawValue

        let commaSeperatedTickersArray = stocks.compactMap { $0.ticker + "," }
        let commaSeperatedTickers = commaSeperatedTickersArray.joined()
        urlString += Endpoints.batch.rawValue + Endpoints.symbols.rawValue + commaSeperatedTickers + "&" + Endpoints.types.rawValue + Types.quote.rawValue
        
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        return URLRequest(url: url)
    }
    
    private func buildURL(for stocks: String, with types: Types?, and requests: Requests?) -> URLRequest? {
        var url = IEXApiClient.baseUrl + Endpoints.stock.rawValue

        url += stocks + "/"
        
        if let request = requests {
            switch request {
            case .chart:
                url += Types.chart.rawValue + Endpoints.chartInterval.rawValue + Duration.marketMonthInDays.rawValue + Endpoints.range.rawValue + Duration.y1.rawValue
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
    
    private func getResults(_ data: Data?, _ response: URLResponse?, _ error: Error?) -> [String: AnyObject]? {
        guard let data = data else { return nil }
        
        var result: [String: AnyObject]?
        
        do {
            result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject]
        } catch let error {
            print(error.localizedDescription)
        }
        
        return result
    }
}

/*
 Unfortunately due to shortcomings of the IEX API dividend information is
 inaccurate as of writing this. Here's a hacky hacky for scraping nasdaq.com's
 dividend page (pretty good info)
 */
extension IEXApiClient {
    
    /// Default 5 yr div history
    public func scrapeDividends(_ stock: String, completion: @escaping ([Dividend]?, Error?) -> Void ) {
        
        if stock == "" { completion(nil, IEXError.stockNameEmpty) }
        
        // hopefully no one minds this... it's publically available information.
        let base = "https://www.nasdaq.com/symbol/"
        let ticker = stock + "/"
        let whole = base + ticker + "dividend-history"
        
        
        guard let url = URL(string: whole) else {
            completion(nil, IEXError.failedScrape)
            return
        }
        
        let req = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: req) { (result, response, error) in
            guard let result = result else { return }
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let doc = String(data: result, encoding: .utf8) {
                let divs = self.parseHTML(html: doc)
                completion(divs, nil)
            }
            
            }.resume()
    }
    
    public func parseHTML(html: String) -> [Dividend]? {
        let doc = try? Kanna.HTML(html: html, encoding: String.Encoding.utf8)
        
        guard let document = doc else { return nil }
        
        let data = document.css("div[id='quotes_content_left_ContentPanel']")
        
        var str = data.first?.text?
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "\\r", with: "", options: .regularExpression)
            .replacingOccurrences(of: "\\t", with: "", options: .regularExpression)
            .replacingOccurrences(of: "\\n", with: " ", options: .regularExpression)
            .replacingOccurrences(of: "[a-zA-Z]", with: "", options: .regularExpression)
            .trimmingCharacters(in: .whitespaces)
        str?.removeFirst()
        let final = str?.trimmingCharacters(in: .whitespaces)
        
        let group = final?
            .components(separatedBy: "  ")
            .filter { $0 != "" }
        
        guard let array = group else { return nil }
        
        var last: Int = 0
        var dividends = [Dividend]()
        for i in 0..<array.count {
            if i == 0 { continue }
            if i % (4 + last) == 0 {
                let ex = array[i-4]
                guard let cashAmount = Double(array[i-3]) else { print("Error retriving dividend in \(#function)"); return nil }
                let declaration = array[i-2]
                let record = array[i-1]
                let payment = array[i]

                let div = Dividend(exDate: ex, paymentDate: payment, recordDate: record, declaredDate: declaration, amount: cashAmount, dividendType: "Cash")
                dividends.append(div)
                last = i + 1
            }
        }
        return dividends
    }
}





