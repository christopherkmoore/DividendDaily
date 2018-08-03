//
//  Dividend.swift
//  DividendDaily
//
//  Created by Christopher Moore on 7/30/18.
//  Copyright © 2018 Christopher Moore. All rights reserved.
//

import Foundation

struct Dividend: Codable {
    
    public var exDate: String
    public var paymentDate: String
    public var recordDate: String
    public var declaredDate: String
    public var amount: Double?
    public var flag: String?
    public var type: String
    public var qualified: String?
    public var indicated: String?
    
}
