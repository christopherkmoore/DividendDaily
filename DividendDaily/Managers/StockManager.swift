//
//  StockManager.swift
//  DividendDaily
//
//  Created by Christopher Moore on 7/30/18.
//  Copyright © 2018 Christopher Moore. All rights reserved.
//

import Foundation


class StockManager {
    
    public static let shared = StockManager()
    
    private init() {}
    
    public private(set) var stocks = [Stock]()
    
    public var numberOfStocks: Int {
        return stocks.count
    }
    
    public func stock(at index: Int) -> Stock? {
        guard index < stocks.count else { return nil }
        
        return stocks[index]
    }
    
    public func add(_ stock: Stock) {
        stocks.append(stock)
    }
    
    /// looks thru stocks to make API calls for stocks with dividend values of nil
    public func updateDividends() {
        
        for index in 0..<stocks.count {
            if stocks[index].dividend == nil {
                IEXApiClient.shared.scrapeDividends(stocks[index]) { (dividends, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    
                    self.stocks[index].dividend = dividends
                }
            }
        }
    }
    

}
