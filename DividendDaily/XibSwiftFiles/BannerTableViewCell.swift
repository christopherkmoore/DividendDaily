//
//  BannerTableViewCell.swift
//  DividendDaily
//
//  Created by Christopher Moore on 8/20/18.
//  Copyright © 2018 Christopher Moore. All rights reserved.
//

import Foundation
import UIKit

class BannerTableViewCell: UITableViewCell {
    
    public static let identifier = "BannerTableViewCell"
    public static let nib = UINib(nibName: BannerTableViewCell.identifier, bundle: nil)
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func set(using stock: Stock) {
        guard let points = stock.chartPoints?.array as? [ChartPoint] else { return }
        
        let chart = Chart(frame: self.frame, with: points)
        chart.backgroundColor = .white
        addSubview(chart)
    }
}
