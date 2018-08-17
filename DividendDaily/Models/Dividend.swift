//
//  Dividend.swift
//  DividendDaily
//
//  Created by Christopher Moore on 7/30/18.
//  Copyright © 2018 Christopher Moore. All rights reserved.
//

import Foundation
import CoreData

public enum InitializationError: Error {
    case CoreDataError
    
    public var localizedDescription: String {
        switch self {
        case .CoreDataError: return "Invalid conscription of entity or managed object context. Set breakpoint to investigate"
        }
    }
}

class Dividend: NSManagedObject, Codable {
    
    @NSManaged public var exDate: String
    @NSManaged public var paymentDate: String
    @NSManaged public var recordDate: String
    @NSManaged public var declaredDate: String
    @NSManaged public var amount: Double
    @NSManaged public var stock: Stock?

    enum CodingKeys: String, CodingKey {
        case exDate = "exDate"
        case paymentDate = "paymentDate"
        case recordDate = "recordDate"
        case declaredDate = "declaredDate"
        case amount = "amount"
        case flag = "flag"
        case type = "type"
        case qualified = "qualified"
        case indicated = "indicated"
    }
    
    
    required convenience init(from decoder: Decoder) throws {
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Dividend", in: CoreDataManager.shared.managedObjectContext) else {
            throw InitializationError.CoreDataError
        }
        self.init(entity: entity, insertInto: CoreDataManager.shared.managedObjectContext)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        exDate = try values.decode(String.self, forKey: .exDate)
        paymentDate = try values.decode(String.self, forKey: .paymentDate)
        recordDate = try values.decode(String.self, forKey: .recordDate)
        declaredDate = try values.decode(String.self, forKey: .declaredDate)
        amount = try values.decode(Double.self, forKey: .amount)
//        flag = try values.decode(String.self, forKey: .flag)
//        dividendType = try values.decode(String.self, forKey: .type)
//        qualified = try values.decode(String.self, forKey: .qualified)
//        indicated  = try values.decode(String.self, forKey: .indicated)
    }
    
    convenience init(exDate: String,
                     paymentDate: String,
                     recordDate: String,
                     declaredDate: String,
                     amount: Double,
                     flag: String? = nil,
                     dividendType: String,
                     qualified: String? = nil,
                     indicated: String? = nil) {
        if let entity = NSEntityDescription.entity(forEntityName: "Dividend", in: CoreDataManager.shared.managedObjectContext) {
            self.init(entity: entity, insertInto: CoreDataManager.shared.managedObjectContext)
            
            self.exDate = exDate
            self.paymentDate = paymentDate
            self.recordDate = recordDate
            self.declaredDate = declaredDate
            self.amount = amount
//            self.flag = flag ?? ""
//            self.dividendType = dividendType
//            self.qualified = qualified ?? ""
//            self.indicated = indicated ?? ""
            
        } else {
            fatalError("fuck")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try values.encode(exDate, forKey: .exDate)
        try values.encode(paymentDate, forKey: .paymentDate)
        try values.encode(recordDate, forKey: .recordDate)
        try values.encode(declaredDate, forKey: .declaredDate)
        try values.encode(amount, forKey: .amount)
//        try values.encode(flag, forKey: .flag)
//        try values.encode(dividendType, forKey: .type)
//        try values.encode(qualified, forKey: .qualified)
//        try values.encode(indicated, forKey: .indicated)
    }
}
