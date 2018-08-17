//
//  StockManager.swift
//  DividendDaily
//
//  Created by Christopher Moore on 7/30/18.
//  Copyright © 2018 Christopher Moore. All rights reserved.
//

import Foundation
import CoreData

// MARK: - Protocols
/// Protocol whose delegates will be notified of changes to the porfolio.
protocol StockManagerDelegate: AnyObject {
    func stocksDidUpdate()
}

class StockManager {
    
    // MARK: Singleton access + Variables
    public static let shared = StockManager.start()
    
    /* This should only ever be called in .start() ONCE! */
    private init() {}
    
    public private(set) var stocks: [Stock] = []
    
    public var delegates = NSHashTable<AnyObject>.weakObjects()
    
    public var numberOfStocks: Int {
        return stocks.count
    }
    
    /*
     For all purposes this method is what should be used to generate the static singleton for this class.
     It should *only* be called once or else there will be other instances of this manager floating around.
    */
    private class func start() -> StockManager {
        let manager = StockManager()
        manager.stocks = manager.retrievePortfolio()
        return manager
    }
    
    //MARK: Protocol methods
    
    /**
     Used to add a delegate to the stock manager. Delegates will be notified of changes so they can respond accordingly.
     - parameters:
        - delegate: The view controller to become a delegate.
    */
    public func addDelegate(_ delegate: StockManagerDelegate) {
        delegates.add(delegate)
    }
    
    /// Returns stock at a given index.
    public func stock(at index: Int) -> Stock? {
        guard index < stocks.count else { return nil }
        return stocks[index]
    }
    
    //MARK: Management methods
    
    /**
     Will add a stock to a private(set) array managed by the StockManager. *WARNING* If a stock is successfully added, all items in the managed object context will be saved, and delegates will also be notified of the change.
     
     - parameters:
        - stock: the stock to be added.
     */
    public func add(_ stock: Stock) {
        if !stocks.contains(where: { $0 == stock }) {
            stocks.append(stock)
            CoreDataManager.shared.save()
            
            for (_, delegate) in delegates.allObjects.enumerated() {
                guard let delegate = delegate as? StockManagerDelegate else { return }
                delegate.stocksDidUpdate()
            }
        }
    }
    
    /// Looks through *ALL* stocks to make API calls for stocks with dividend values of nil.
    public func updateDividends() {
        
        for index in 0..<stocks.count {
            if stocks[index].dividend == nil {
                IEXApiClient.shared.scrapeDividends(stocks[index]) { (dividends, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    
                    if let dividends = dividends {
                        let set = NSOrderedSet(array: dividends)
                        self.stocks[index].dividend = set
                    }
                }
            }
        }
    }
    
    /// Call to core data to retrieve a portfolio.
    private func retrievePortfolio() -> [Stock] {
        let request = NSFetchRequest<Stock>(entityName: "Stock")
        
        do {
            let result = try CoreDataManager.shared.managedObjectContext.fetch(request)
            print(result)
            return result
        } catch let error {
            print(error.localizedDescription)
        }
        return []
    }
}

