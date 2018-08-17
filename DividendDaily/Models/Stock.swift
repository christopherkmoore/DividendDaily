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

extension Stock {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Stock> {
        return NSFetchRequest<Stock>(entityName: "Stock")
    }
    
    @NSManaged public var ticker: String
    @NSManaged public var dividend: NSOrderedSet?
    @NSManaged public var quote: Quote?
    
}

// MARK: Generated accessors for dividend
extension Stock {
    
    @objc(insertObject:inDividendAtIndex:)
    @NSManaged public func insertIntoDividend(_ value: Dividend, at idx: Int)
    
    @objc(removeObjectFromDividendAtIndex:)
    @NSManaged public func removeFromDividend(at idx: Int)
    
    @objc(insertDividend:atIndexes:)
    @NSManaged public func insertIntoDividend(_ values: [Dividend], at indexes: NSIndexSet)
    
    @objc(removeDividendAtIndexes:)
    @NSManaged public func removeFromDividend(at indexes: NSIndexSet)
    
    @objc(replaceObjectInDividendAtIndex:withObject:)
    @NSManaged public func replaceDividend(at idx: Int, with value: Dividend)
    
    @objc(replaceDividendAtIndexes:withDividend:)
    @NSManaged public func replaceDividend(at indexes: NSIndexSet, with values: [Dividend])
    
    @objc(addDividendObject:)
    @NSManaged public func addToDividend(_ value: Dividend)
    
    @objc(removeDividendObject:)
    @NSManaged public func removeFromDividend(_ value: Dividend)
    
    @objc(addDividend:)
    @NSManaged public func addToDividend(_ values: NSOrderedSet)
    
    @objc(removeDividend:)
    @NSManaged public func removeFromDividend(_ values: NSOrderedSet)
    
}

