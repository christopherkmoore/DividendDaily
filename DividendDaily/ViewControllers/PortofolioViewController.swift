//
//  PortofolioViewController.swift
//  DividendDaily
//
//  Created by Christopher Moore on 7/8/18.
//  Copyright © 2018 Christopher Moore. All rights reserved.
//

import Foundation
import UIKit

class PortfolioViewController: UIViewController {
    
    @IBOutlet weak var stockTableView: UITableView!
    
    var viewModel = PortofolioViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stockTableView.delegate = self
        stockTableView.dataSource = self
        
        stockTableView.register(StockTableViewCell.nib, forCellReuseIdentifier: StockTableViewCell.identifier)
        stockTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    @IBAction func addStock(_ sender: Any) {
        let alert = UIAlertController(title: "add new stock", message: "What would you like to add?", preferredStyle: .alert)
        alert.addTextField { (textField) in
            
        }
        let add = UIAlertAction(title: "Add", style: .default) { (action) in
            guard let text = alert.textFields?.first?.text else { return }
            self.search(with: text)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(add)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func search(with text: String) {
    
        IEXApiClient.shared.getStock(text) { (success, result) in
            if let quote = result {
                let stock = Stock(ticker: quote.symbol, quote: quote, dividend: nil)
                StockManager.shared.add(stock)
                StockManager.shared.updateDividends()
            }
        
            DispatchQueue.main.async {
                self.stockTableView.reloadData()
            }
        }
    }
}

extension PortfolioViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StockTableViewCell.identifier) as? StockTableViewCell else { return UITableViewCell() }
        
        cell.set(using: viewModel, at: indexPath.row)
        
        return cell
    }
    
    
}
