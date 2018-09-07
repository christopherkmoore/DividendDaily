//
//  LastUpdatedTableViewCell.swift
//  DividendDaily
//
//  Created by Christopher Moore on 9/7/18.
//  Copyright © 2018 Christopher Moore. All rights reserved.
//

import Foundation
import UIKit

class LastUpdatedTableViewCell: UITableViewCell {
    
    public static let identifier = "LastUpdatedTableViewCell"
    public static let nib = UINib(nibName: LastUpdatedTableViewCell.identifier, bundle: nil)
    @IBOutlet weak var lastUpdatedLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func set(using viewModel: PortofolioViewModel?, at index: Int) {
        
        guard index == 0 else {
            return
        }
        
        var final: String
        if let lastUpdated = viewModel?.lastUpdatedTime {
            // check if it's today. If it is, take the date and leave the time
            if Calendar.current.isDateInToday(lastUpdated) {
                final = DateFormatter.localizedString(from: lastUpdated, dateStyle: .none, timeStyle: .long)
                lastUpdatedLabel.text = "Last updated: \(final)"
            } else {
                lastUpdatedLabel.textColor = .red
                final = DateFormatter.localizedString(from: lastUpdated, dateStyle: .medium, timeStyle: .long)
                lastUpdatedLabel.text = "Last updated: \(final)"
            }
        }
    }

}
