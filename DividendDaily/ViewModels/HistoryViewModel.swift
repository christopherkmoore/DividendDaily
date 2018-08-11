//
//  HistoryViewModel.swift
//  DividendDaily
//
//  Created by Christopher Moore on 7/30/18.
//  Copyright © 2018 Christopher Moore. All rights reserved.
//

import Foundation


class HistoryViewModel {
    
    static let ex = " is going ex: "
    static let payable = " is paying: "
    
    var upcomingExDividends = [[String: String]]()
    var upcomingPayments = [[String: String]]()
    
    var finalDividendHistory = [[String: String]]()
    
    
    func lookEx() {
        upcomingExDividends = []
        
        StockManager.shared.stocks.forEach {
            guard let div = $0.dividend?.first?.exDate else { return }
            let name = $0.ticker.uppercased()
            let text = name + HistoryViewModel.ex
            upcomingExDividends.append([text: div])
        }
        var filtered = dividendsIn(30, for: upcomingExDividends)
        upcomingExDividends = sortDivs(dividends: &filtered)
    }
    
    func lookPayment() {
        upcomingPayments = []
        StockManager.shared.stocks.forEach {
            guard let div = $0.dividend?.first else { return }
            let name = $0.ticker.uppercased()
            let text = name + HistoryViewModel.payable
            upcomingPayments.append([text: div.paymentDate])
        }
        var filtered = dividendsIn(30, for: upcomingPayments)
        upcomingPayments = sortDivs(dividends: &filtered)

    }
    
    func searchDividendData() {
        lookEx()
        lookPayment()
        
        finalDividendHistory = upcomingPayments + upcomingExDividends
        _ = sortDivs(dividends: &finalDividendHistory)
        
    }
    
    private func sortDivs( dividends: inout [[String: String]]) -> [[String: String]] {

        return dividends.sorted { (first, second) -> Bool in
            if
                let date1 = first.values.first,
                let date2 = second.values.first,
                let firstDate = DateFormatter.mMddyyyDashFormatter.date(from: date1),
                let secondDate = DateFormatter.mMddyyyDashFormatter.date(from: date2) {
                return firstDate < secondDate
            }
            return false
        }
    }
    
    private func dividendsIn(_ days: Int, for stocks: [[String: String]]) -> [[String: String]] {
        
        /* days * hours * minutes * seconds */
        let thresholdInterval: TimeInterval = TimeInterval(days * 24 * 60 * 60)
        
        let acceptableRange = stocks.filter {
            
            guard let string = $0.first?.value,
                let date = DateFormatter.mMddyyyDashFormatter.date(from: string) else {
                    return true
            }
                /* filter anything past 30 days or 15 days before today */
            if date.timeIntervalSinceNow > (thresholdInterval * -0.5)  {
                if date.timeIntervalSinceNow >= thresholdInterval {
                    return false
                } else {
                    return true
                }
            } else {
                return false
            }
        }
        return acceptableRange
    }
}
