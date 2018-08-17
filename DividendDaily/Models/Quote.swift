//
//  Quote.swift
//  DividendDaily
//
//  Created by Christopher Moore on 7/9/18.
//  Copyright © 2018 Christopher Moore. All rights reserved.
//

import Foundation
import CoreData

class Quote: NSManagedObject, Codable {
    
    enum CodingKeys: String, CodingKey {
        case quote // parent object holding dividend
        
        case symbol
        case companyName
        case primaryExchange
        case sector
        case calculationPrice
        case open
        case openTime // transform needed? (date)
        case close
        case closeTime
        case high
        case low
        case latestPrice
        case latestSource
        case latestTime
        case latestUpdate // transform needed? (date)
        case latestVolume
        case iexRealtimePrice
        case iexRealtimeSize
        case iexLastUpdated // transform needed? (date)
        case delayedPrice
        case delayedPriceTime
        case extendedPrice
        case extendedChange
        case extendedChangePercent
        case extendedPriceTime // transform needed?
        case previousClose
        case change
        case changePercent
        case iexMarketPercent
        case iexVolume
        case avgTotalVolume
        case iexBidPrice
        case iexBidSize
        case iexAskPrice
        case iexAskSize
        case marketCap // transform needed?
        case peRatio
        case week52High
        case week52Low
        case ytdChange
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let entity = NSEntityDescription.entity(forEntityName: "Quote", in: CoreDataManager.shared.managedObjectContext) else {
            throw InitializationError.CoreDataError
            
        }
        self.init(entity: entity, insertInto: CoreDataManager.shared.managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let quote = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .quote)
        symbol = try quote.decode(String.self, forKey: .symbol)
        companyName = try quote.decode(String.self, forKey: .companyName)
        primaryExchange = try quote.decode(String.self, forKey: .primaryExchange)
        sector = try quote.decode(String.self, forKey: .sector)
        calculationPrice = try quote.decode(String.self, forKey: .calculationPrice)
        open = try quote.decode(Double.self, forKey: .open)
        openTime = try quote.decode(Int64.self, forKey: .openTime)
        close = try quote.decode(Double.self, forKey: .close)
        closeTime = try quote.decode(Int64.self, forKey: .closeTime)
        high = try quote.decode(Double.self, forKey: .high)
        low = try quote.decode(Double.self, forKey: .low)
        latestPrice = try quote.decode(Double.self, forKey: .latestPrice)
        latestSource = try quote.decode(String.self, forKey: .latestSource)
        latestTime = try quote.decode(String.self, forKey: .latestTime)
        latestUpdate = try quote.decode(Int64.self, forKey: .latestUpdate)
        latestVolume = try quote.decode(Int64.self, forKey: .latestVolume)
        iexRealtimePrice = try quote.decode(Double.self, forKey: .iexRealtimePrice)
        iexRealtimeSize = try quote.decode(Int16.self, forKey: .iexRealtimeSize)
        iexLastUpdated = try quote.decode(Int64.self, forKey: .iexLastUpdated)
        delayedPrice = try quote.decode(Double.self, forKey: .delayedPrice)
        delayedPriceTime = try quote.decode(Int64.self, forKey: .delayedPriceTime)
        extendedPrice = try quote.decode(Double.self, forKey: .extendedPrice)
        extendedChange = try quote.decode(Double.self, forKey: .extendedChange)
        extendedChangePercent = try quote.decode(Double.self, forKey: .extendedChangePercent)
        extendedPriceTime = try quote.decode(Int64.self, forKey: .extendedPriceTime)
        previousClose = try quote.decode(Double.self, forKey: .previousClose)
        change = try quote.decode(Double.self, forKey: .change)
        changePercent = try quote.decode(Double.self, forKey: .changePercent)
        iexMarketPercent = try quote.decode(Double.self, forKey: .iexMarketPercent)
        iexVolume = try quote.decode(Int32.self, forKey: .iexVolume)
        avgTotalVolume = try quote.decode(Int64.self, forKey: .avgTotalVolume)
        iexBidPrice = try quote.decode(Double.self, forKey: .iexBidPrice)
        iexBidSize = try quote.decode(Int16.self, forKey: .iexBidSize)
        iexAskPrice = try quote.decode(Double.self, forKey: .iexAskPrice)
        iexAskSize = try quote.decode(Int16.self, forKey: .iexAskSize)
        marketCap = try quote.decode(Int64.self, forKey: .marketCap)
        peRatio = try quote.decode(Double.self, forKey: .peRatio)
        week52High = try quote.decode(Double.self, forKey: .week52High)
        week52Low = try quote.decode(Double.self, forKey: .week52Low)
        ytdChange = try quote.decode(Float.self, forKey: .ytdChange)
    }
    
    func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        
        try values.encode(symbol, forKey: .symbol)
        try values.encode(companyName, forKey: .companyName)
        try values.encode(primaryExchange, forKey: .primaryExchange)
        try values.encode(sector, forKey: .sector)
        try values.encode(calculationPrice, forKey: .calculationPrice)
        try values.encode(open, forKey: .open)
        try values.encode(openTime, forKey: .openTime)
        try values.encode(close, forKey: .close)
        try values.encode(closeTime, forKey: .closeTime)
        try values.encode(high, forKey: .high)
        try values.encode(low, forKey: .low)
        try values.encode(latestPrice, forKey: .latestPrice)
        try values.encode(latestSource, forKey: .latestSource)
        try values.encode(latestTime, forKey: .latestTime)
        try values.encode(latestUpdate, forKey: .latestUpdate)
        try values.encode(latestVolume, forKey: .latestVolume)
        try values.encode(iexRealtimePrice, forKey: .iexRealtimePrice)
        try values.encode(iexRealtimeSize, forKey: .iexRealtimeSize)
        try values.encode(iexLastUpdated, forKey: .iexLastUpdated)
        try values.encode(delayedPrice, forKey: .delayedPrice)
        try values.encode(delayedPriceTime, forKey: .delayedPriceTime)
        try values.encode(extendedPrice, forKey: .extendedPrice)
        try values.encode(extendedChange, forKey: .extendedChange)
        try values.encode(extendedChangePercent, forKey: .extendedChangePercent)
        try values.encode(extendedPriceTime, forKey: .extendedPriceTime)
        try values.encode(previousClose, forKey: .previousClose)
        try values.encode(change, forKey: .change)
        try values.encode(changePercent, forKey: .changePercent)
        try values.encode(iexMarketPercent, forKey: .iexMarketPercent)
        try values.encode(iexVolume, forKey: .iexVolume)
        try values.encode(avgTotalVolume, forKey: .avgTotalVolume)
        try values.encode(iexBidPrice, forKey: .iexBidPrice)
        try values.encode(iexBidSize, forKey: .iexBidSize)
        try values.encode(iexAskPrice, forKey: .iexAskPrice)
        try values.encode(iexAskSize, forKey: .iexAskSize)
        try values.encode(marketCap, forKey: .marketCap)
        try values.encode(peRatio, forKey: .peRatio)
        try values.encode(week52High, forKey: .week52High)
        try values.encode(week52Low, forKey: .week52Low)
        try values.encode(ytdChange, forKey: .ytdChange)
    }

}
