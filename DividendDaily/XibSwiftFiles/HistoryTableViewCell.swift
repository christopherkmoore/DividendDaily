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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func set(using viewModel: PortofolioViewModel, at index: Int) {
        
    }
    
    
}

