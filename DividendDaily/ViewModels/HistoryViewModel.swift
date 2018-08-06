//
//  HistoryViewModel.swift
//  DividendDaily
//
//  Created by Christopher Moore on 7/30/18.
//  Copyright © 2018 Christopher Moore. All rights reserved.
//

import Foundation


class HistoryViewModel {
    
    var upcomingExDividends = [[String: Dividend]]()
    
    // func to pick out upcoming dividends (within 30 days?)
    
    func lookEx() {
        upcomingExDividends = []
        
        StockManager.shared.stocks.forEach {
            guard let name = $0.quote?.companyName else { print("company name nil"); return}
            guard let div = $0.dividend?.first else { print("dividend is not present"); return }
            upcomingExDividends.append([name:div])
        }
    }
    
    // func to look for increases
    
    // func to find divs just gone ex
    
    
}
