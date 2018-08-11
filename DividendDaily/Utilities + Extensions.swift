//
//  Utilities + Extensions.swift
//  DividendDaily
//
//  Created by Christopher Moore on 8/8/18.
//  Copyright © 2018 Christopher Moore. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    public static var mMddyyyDashFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        formatter.dateStyle = .short
        formatter.timeZone = .current
        formatter.timeStyle = .none
        
        return formatter
    }
}
