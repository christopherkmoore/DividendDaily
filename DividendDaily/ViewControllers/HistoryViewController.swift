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
    
    @IBAction func addStock(_ sender: Any) {
        let alert = UIAlertController(title: "add new stock", message: "What would you like to add?", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        
        let add = UIAlertAction(title: "Add", style: .default) { (action) in
            guard let text = alert.textFields?.first?.text else { return }
            search(with: text)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(add)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        
        func search(with text: String) {
            let ticker = text.uppercased()
            
            IEXApiClient.shared.getStock(ticker) { (success, result) in
                guard success else { return }
                if let stock = result {
                    StockManager.shared.add(stock)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if stockDelegate == nil {
            self.stockDelegate = self
            StockManager.shared.addDelegate(stockDelegate)
        }
        
        if divHistoryViewModel == nil {
            self.divHistoryViewModel = HistoryViewModel()
            self.divHistoryViewModel?.searchDividendData()
        }
        
        historyTableView.delegate = self
        historyTableView.dataSource = self
        
        historyTableView.register(HistoryTableViewCell.nib, forCellReuseIdentifier: HistoryTableViewCell.identifier)
        historyTableView.rowHeight = UITableViewAutomaticDimension
    }
}

extension HistoryViewController: StockManagerDelegate {
    func stocksDidUpdate() {
        divHistoryViewModel?.searchDividendData()
        DispatchQueue.main.async {
            self.historyTableView.reloadData()
        }  
    }
}

extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = divHistoryViewModel?.finalDividendHistory.compactMap { $0 }.count
        
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
