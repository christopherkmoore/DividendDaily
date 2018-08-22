//
//  StockDetailViewModel.swift
//  DividendDaily
//
//  Created by Christopher Moore on 8/18/18.
//  Copyright © 2018 Christopher Moore. All rights reserved.
//

import Foundation

class StockDetailViewModel {
    
    public var stock: Stock
    
    init(using stock: Stock) {
        self.stock = stock
    }
    
    public func getChartData(for stock: Stock) {
        IEXApiClient.shared.getChartData(for: stock) { (success, stock) in
            guard
                let stock = stock,
                let chartPoints = stock.chartPoints
            else { return }
            StockManager.shared.update(stock, using: chartPoints)
            self.stock = stock
        }
    }    
}
