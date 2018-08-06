//
//  HistoryViewController.swift
//  DividendDaily
//
//  Created by Christopher Moore on 7/30/18.
//  Copyright © 2018 Christopher Moore. All rights reserved.
//

import Foundation
import UIKit

class HistoryViewController: UIViewController {
    
    @IBOutlet weak var historyTableView: UITableView!
    
    var divHistoryViewModel: HistoryViewModel?
    weak var stockDelegate: StockManagerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if stockDelegate == nil {
            self.stockDelegate = self
            StockManager.shared.addDelegate(stockDelegate)
        }
        
        if divHistoryViewModel == nil {
            self.divHistoryViewModel = HistoryViewModel()
            self.divHistoryViewModel?.lookEx()
        }
        
        historyTableView.delegate = self
        historyTableView.dataSource = self
        
        historyTableView.register(HistoryTableViewCell.nib, forCellReuseIdentifier: HistoryTableViewCell.identifier)
        historyTableView.rowHeight = UITableViewAutomaticDimension
    }
}

extension HistoryViewController: StockManagerDelegate {
    func stocksDidUpdate() {
        divHistoryViewModel?.lookEx()
        DispatchQueue.main.async {
            self.historyTableView.reloadData()
        }  
    }
}

extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = divHistoryViewModel?.upcomingExDividends.compactMap { $0 }.count
        
        if let count = count {
            return count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.identifier) as? HistoryTableViewCell else { return UITableViewCell() }
        
        cell.set(using: divHistoryViewModel, at: indexPath.row)
        
        return cell
    }
    
    
}
