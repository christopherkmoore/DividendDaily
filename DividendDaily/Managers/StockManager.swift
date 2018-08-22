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
        if !stocks.contains(where: {$0.ticker == stock.ticker}) {
            stocks.append(stock)
            CoreDataManager.shared.save()
            notifyDelegates()
        }
    }
    
    /**
     Certain Core Data objects are initialized and have properties set later. Chart Points is an example of a delayed fetch where the object is instead 'updated' instead of saved again completely. The in memory array is updated by the Stock Manager, and updated by the Core Data Manager
     
     - parameters:
     - stock: The stock to be updated
     - using chartPoints: the chart points to be added to the Stock object.
     */

    
    public func update(_ stock: Stock, using chartPoints: NSOrderedSet) {
        var updatedStocks: [Stock]
        updatedStocks = stocks.filter {
            $0.ticker != stock.ticker
        }
        updatedStocks.append(stock)
        CoreDataManager.shared.update(stock, using: chartPoints)
    }
    
    /**
     Will remove a stock to a private(set) array managed by the StockManager. *WARNING* If a stock is successfully removed, all items in the managed object context will be saved, and delegates will also be notified of the change.
     
     - parameters:
     - at index: The index at which to remove the stock.
     */
    
    public func remove(at index: Int) {
        if index < stocks.count {
            let stock = stocks.remove(at: index) as NSManagedObject
            CoreDataManager.shared.delete(stock)
            notifyDelegates()
        }
    }
    
    /// Notify Delegates of a change in the porfolio so views can be refreshed
    private func notifyDelegates() {
        for (_, delegate) in delegates.allObjects.enumerated() {
            guard let delegate = delegate as? StockManagerDelegate else { return }
            delegate.stocksDidUpdate()
        }
    }
    
    /// Looks through *ALL* stocks to make API calls for stocks with dividend values of nil.
    public func updateDividends() {
        
        for index in 0..<stocks.count {
            if stocks[index].dividend == nil {
                IEXApiClient.shared.scrapeDividends(stocks[index].ticker) { (dividends, error) in
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
    
    public func refreshStocks() {
        IEXApiClient.shared.refreshQuote(for: stocks) { (success, stocks) in
            guard success else { return }
            guard let updatedStocks = stocks else { return }

            self.stocks = updatedStocks
            CoreDataManager.shared.save()
            self.notifyDelegates()
        }
    }
    
    /// Call to core data to retrieve a portfolio.
    private func retrievePortfolio() -> [Stock] {
        let request = NSFetchRequest<Stock>(entityName: "Stock")
        
        do {
            let result = try CoreDataManager.shared.managedObjectContext.fetch(request)
            return result
        } catch let error {
            print(error.localizedDescription)
        }
        return []
    }
}

