//
//  Utilities.swift
//  DividendDaily
//
//  Created by Christopher Moore on 7/31/18.
//  Copyright © 2018 Christopher Moore. All rights reserved.
//

import Foundation

extension DateFormatter {
    static var yyyyMMdd: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")

        return formatter
    }
}