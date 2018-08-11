//
//  HistoryTableViewCell.swift
//  DividendDaily
//
//  Created by Christopher Moore on 7/30/18.
//  Copyright © 2018 Christopher Moore. All rights reserved.
//

import Foundation
import UIKit
import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    public static let identifier = "HistoryTableViewCell"
    public static let nib = UINib(nibName: HistoryTableViewCell.identifier, bundle: nil)
    
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func set(using viewModel: HistoryViewModel?, at index: Int) {
        let div = viewModel?.upcomingExDividends[index]
        
        guard
            let key = div?.first?.key,
            let value = div?.first?.value else {
                return
        }
        
        let text = key.uppercased() + " is going ex: " + value + " "
        rightTextLabel.text = text
    }
    
    
}

