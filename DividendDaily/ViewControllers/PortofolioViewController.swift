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
    weak var stockDelegate: StockManagerDelegate!
    private var refreshControl = UIRefreshControl()

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
            do {
                let ticker = text.uppercased()
                
                IEXApiClient.shared.getStock(ticker) { (success, result) in
                    guard success else { return }
                    if let stock = result {
                        
                        StockManager.shared.add(stock)
                    }
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if stockDelegate == nil {
            self.stockDelegate = self
            StockManager.shared.addDelegate(stockDelegate)
        }
        
        stockTableView.delegate = self
        stockTableView.dataSource = self
        stockTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshStocks), for: .valueChanged)
        
        stockTableView.register(StockTableViewCell.nib, forCellReuseIdentifier: StockTableViewCell.identifier)
        stockTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    @objc func refreshStocks() {
        StockManager.shared.refreshStocks()
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
        }
    }
}

extension PortfolioViewController: StockManagerDelegate {
    func stocksDidUpdate() {
        DispatchQueue.main.async {
            self.stockTableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard
            let stock = StockManager.shared.stock(at: indexPath.row),
            let controller = storyboard?.instantiateViewController(withIdentifier: "StockDetailViewController") as? StockDetailViewController else {
            return
        }
        
        controller.stock = stock
        self.showDetailViewController(controller, sender: self)
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            StockManager.shared.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
}
