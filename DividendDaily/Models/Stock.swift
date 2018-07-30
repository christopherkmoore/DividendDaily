//
//  Stock.swift
//  DividendDaily
//
//  Created by Christopher Moore on 7/8/18.
//  Copyright © 2018 Christopher Moore. All rights reserved.
//

import Foundation

struct Stock: Codable {
    
    public let ticker: String
    public let quote: Quote?
    
}
