//
//  Stock.swift
//  DividendDaily
//
//  Created by Christopher Moore on 7/8/18.
//  Copyright © 2018 Christopher Moore. All rights reserved.
//

import Foundation

struct Stock: Equatable, Codable {

    init(_ stock: Stock) {
        self = stock
    }
    
    init(ticker: String, quote: Quote? = nil, dividend: [Dividend]? = nil) {
        self.ticker = ticker
        self.quote = quote
        self .dividend = dividend
    }
    
    public var ticker: String
    public var quote: Quote?
    public var dividend: [Dividend]?
    
    static func == (lhs: Stock, rhs: Stock) -> Bool {
        return
            lhs.dividend == rhs.dividend &&
            lhs.quote == rhs.quote &&
            lhs.ticker == rhs.ticker
    }
}
