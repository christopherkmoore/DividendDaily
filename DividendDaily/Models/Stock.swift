//
//  Stock.swift
//  DividendDaily
//
//  Created by Christopher Moore on 7/8/18.
//  Copyright © 2018 Christopher Moore. All rights reserved.
//

import Foundation
import CoreData

class Stock: NSManagedObject {

    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(ticker: String, quote: Quote? = nil, dividend: NSOrderedSet? = nil) throws {
        
        if let entity = NSEntityDescription.entity(forEntityName: "Stock", in: CoreDataManager.shared.managedObjectContext) {
            super.init(entity: entity, insertInto: CoreDataManager.shared.managedObjectContext)
            
            self.ticker = ticker
            self.quote = quote
            self.dividend = dividend
        } else {
            throw InitializationError.CoreDataError
        }
    }
}


