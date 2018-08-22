//
//  CoreDataStack.swift
//  DividendDaily
//
//  Created by Christopher Moore on 8/11/18.
//  Copyright © 2018 Christopher Moore. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    // MARK: - Properties
    
    private let modelName: String = "DividendDaily"
    
    private init() {}
    
    public static let shared = CoreDataManager()
    
    // MARK: - Core Date Properties
    
    public private(set) lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        
        return managedObjectContext
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let url = Bundle.main.url(forResource: modelName, withExtension: "momd") else {
            fatalError("Unable to find data model \(#function)")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Unable to initialize NSMAngedObjectModel(_contentsOf:)")
        }
        
        return managedObjectModel
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStore = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        let fileManager = FileManager.default
        let storeName = "\(modelName).sqlite"
        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        let persistentStoreURL = documentsDirectoryURL?.appendingPathComponent(storeName)
        
        do {
            try persistentStore.addPersistentStore(ofType: NSSQLiteStoreType,
                                                   configurationName: nil,
                                                   at: persistentStoreURL, options: nil)
        } catch let error {
            fatalError(error.localizedDescription)
        }
        
        return persistentStore
    }()
    
    public func delete(_ object: NSManagedObject) {
        do {
            managedObjectContext.delete(object)
            try managedObjectContext.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    public func update(_ stock: Stock, using chartPoints: NSOrderedSet) {
        let managedObject = stock as NSManagedObject
        if managedObject.hasChanges {
            managedObject.setValue(chartPoints, forKey: "chartPoints")
            
            do {
                try managedObjectContext.save()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    public func save() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}
