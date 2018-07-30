//
//  StockTableViewCell.swift
//  DividendDaily
//
//  Created by Christopher Moore on 7/9/18.
//  Copyright © 2018 Christopher Moore. All rights reserved.
//

import Foundation
import UIKit

class StockTableViewCell: UITableViewCell {
    
    public static let identifier = "StockTableViewCell"
    public static let nib = UINib(nibName: StockTableViewCell.identifier, bundle: nil)
    
    @IBOutlet weak var stockNameLabel: UILabel!
    @IBOutlet weak var tickerLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var todaysChangeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func set(using viewModel: PortofolioViewModel, at index: Int) {
        guard let stock = StockManager.shared.stock(at: index) else {
            print("Index out of bounds for stocks array at \(index)")
            return
        }
        
        stockNameLabel.text = stock.quote?.companyName
        tickerLabel.text = stock.quote?.symbol
        
        priceLabel.text = "$" + String(format: "%.2f", stock.quote?.latestPrice ?? 0)
        let todaysChange = viewModel.todaysChange(stock)
        if todaysChange.first == "-" {
            todaysChangeLabel.textColor = .red
        } else {
            todaysChangeLabel.textColor = .green
        }
        todaysChangeLabel.text = todaysChange
    }
    
    
}
