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
            guard let div = $0.dividend?.first else { print("dividend is not present"); return }
            let name = $0.ticker
            upcomingExDividends.append([name:div])
        }
        sortDivs()
    }
    
    func lookPayment() {
        
    }
    
    private func sortDivs() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        formatter.dateStyle = .short
        formatter.timeZone = .current
        formatter.timeStyle = .none
        
        upcomingExDividends.sort { (first, second) -> Bool in
            if
                let date1 = first.values.first?.exDate,
                let date2 = second.values.first?.exDate,
                let firstDate = formatter.date(from: date1),
                let secondDate = formatter.date(from: date2) {
                    return firstDate < secondDate
            }
            return false
        }
    }
    
    // func to look for increases
    
    // func to find divs just gone ex
    
    
}
