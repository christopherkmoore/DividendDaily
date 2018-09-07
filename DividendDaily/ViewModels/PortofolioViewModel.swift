//
//  PortofolioViewModel.swift
//  DividendDaily
//
//  Created by Christopher Moore on 7/9/18.
//  Copyright © 2018 Christopher Moore. All rights reserved.
//

import Foundation

class PortofolioViewModel {
        
    public var numberOfCells: Int {
        return StockManager.shared.numberOfStocks
    }
    
    public func todaysChange(_ stock: Stock) -> String {
        if let open = stock.quote?.open,
            let latest = stock.quote?.latestPrice {
            
            let todaysChange = open - latest
            let rounded = String(format: "%.2f", todaysChange)
            return rounded
        }
        
        return ""
    }
    
    public func todaysChangePercent(_ stock: Stock) -> String {
        if
            let openPrice = stock.quote?.open,
            let current = stock.quote?.latestPrice {
                let diff = ((current - openPrice) / openPrice) * -100
                return String(format: "%.2f", diff) + "%"
        }
        return "--"
    }
    
    public var lastUpdatedTime: Date? {
        
        guard let last = StockManager.shared.stocks.first?.quote?.latestUpdate else { return nil }
        let formatted = Double(last) * 0.001
        let interval = TimeInterval(formatted)
        return Date(timeIntervalSince1970: interval)
        
        
    }
}
