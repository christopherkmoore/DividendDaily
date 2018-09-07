//
//  ChartPoint.swift
//  DividendDaily
//
//  Created by Christopher Moore on 8/20/18.
//  Copyright © 2018 Christopher Moore. All rights reserved.
//

import Foundation
import CoreData

class ChartPoint: NSManagedObject, Decodable {
    
    /* Ex return in an array of objects
     
     "date": "2017-08-17",
     "open": 158.129,
     "high": 158.3162,
     "low": 155.4889,
     "close": 155.5086,
     "volume": 27940565,
     "unadjustedVolume": 27940565,
     "change": -3.044,
     "changePercent": -1.92,
     "vwap": 156.5411,
     "label": "Aug 17, 17",
     "changeOverTime": 0
    */
    
    @NSManaged public var date: String
    @NSManaged public var open: Double
    @NSManaged public var high: Double
    @NSManaged public var low: Double
    @NSManaged public var close: Double
    @NSManaged public var volume: Int64
    @NSManaged public var unadjustedVolume: Int64
    @NSManaged public var change: Double
    @NSManaged public var changePercent: Double
    @NSManaged public var vwap: Double
    @NSManaged public var dateLabelMMMddyy: String
    @NSManaged public var changeOverTime: Double
    @NSManaged public var stock: Stock?
    
    enum CodingKeys: String, CodingKey {
        case date
        case open
        case high
        case low
        case close
        case volume
        case unadjustedVolume
        case change
        case changePercent
        case vwap
        case dateLabelMMMddyy = "label"
        case changeOverTime
    }
    
    required convenience init(from decoder: Decoder) throws {
        
        guard let entity = NSEntityDescription.entity(forEntityName: "ChartPoint", in: CoreDataManager.shared.managedObjectContext) else {
            throw InitializationError.CoreDataError
        }
        self.init(entity: entity, insertInto: CoreDataManager.shared.managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        date = try container.decode(String.self, forKey: .date)
        open = try container.decode(Double.self, forKey: .open)
        high = try container.decode(Double.self, forKey: .high)
        low = try container.decode(Double.self, forKey: .low)
        close = try container.decode(Double.self, forKey: .close)
        volume = try container.decode(Int64.self, forKey: .volume)
        unadjustedVolume = try container.decode(Int64.self, forKey: .unadjustedVolume)
        change = try container.decode(Double.self, forKey: .change)
        changePercent = try container.decode(Double.self, forKey: .changePercent)
        vwap = try container.decode(Double.self, forKey: .vwap)
        dateLabelMMMddyy = try container.decode(String.self, forKey: .dateLabelMMMddyy)
        changeOverTime = try container.decode(Double.self, forKey: .changeOverTime)
    }
}
