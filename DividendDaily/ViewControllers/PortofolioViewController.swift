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
            let incompleteStock = Stock(ticker: text, quote: nil, dividend: nil)
            
            IEXApiClient.shared.getStock(incompleteStock) { (success, result) in
                guard success else { return }
                if let stock = result {
                    StockManager.shared.add(stock)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stockTableView.delegate = self
        stockTableView.dataSource = self
        
        stockTableView.register(StockTableViewCell.nib, forCellReuseIdentifier: StockTableViewCell.identifier)
        stockTableView.rowHeight = UITableViewAutomaticDimension
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
