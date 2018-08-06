//
//  Quote.swift
//  DividendDaily
//
//  Created by Christopher Moore on 7/9/18.
//  Copyright © 2018 Christopher Moore. All rights reserved.
//

import Foundation

struct Quote: Equatable, Codable {
    
    public var symbol: String
    public var companyName: String
    public var primaryExchange: String
    public var sector: String
    public var calculationPrice: String
    public var open: Double
    public var openTime: Int64 // transform needed?
    public var close: Double
    public var closeTime: Int64 // transform needed?
    public var high: Double
    public var low: Double
    public var latestPrice: Double
    public var latestSource: String
    public var latestTime: String
    public var latestUpdate: Int64 // transform needed?
    public var latestVolume: Int64 // transform needed?
    public var iexRealtimePrice: Double?
    public var iexRealtimeSize: Int?
    public var iexLastUpdated: Int64? // transform needed?
    public var delayedPrice: Double
    public var delayedPriceTime: Int64
    public var extendedPrice: Double
    public var extendedChange: Double
    public var extendedChangePercent: Double
    public var extendedPriceTime: Int64 // transform needed?
    public var previousClose: Double
    public var change: Double
    public var changePercent: Double
    public var iexMarketPercent: Double?
    public var iexVolume: Int?
    public var avgTotalVolume: Int
    public var iexBidPrice: Double?
    public var iexBidSize: Int?
    public var iexAskPrice: Double?
    public var iexAskSize: Int?
    public var marketCap: Int64 // transform needed?
    public var peRatio: Double
    public var week52High: Double
    public var week52Low: Double
    public var ytdChange: Float
     
}
