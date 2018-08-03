//
//  Stock.swift
//  DividendDaily
//
//  Created by Christopher Moore on 7/8/18.
//  Copyright © 2018 Christopher Moore. All rights reserved.
//

import Foundation

struct Stock: Codable {
    
    public var ticker: String
    public var quote: Quote?
    public var dividend: [Dividend]?
}
