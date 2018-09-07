//
//  StockDetailViewController.swift
//  DividendDaily
//
//  Created by Christopher Moore on 8/18/18.
//  Copyright © 2018 Christopher Moore. All rights reserved.
//

import Foundation
import UIKit

class StockDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var stock: Stock! {
        didSet {
            // wait for API call to finish to load the chart
            if stock.chartPoints != nil,
                tableView != nil {
                DispatchQueue.main.async {
                    self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                }
            }
        }
    }
    weak var stockDelegate: StockManagerDelegate!
    var viewModel: StockDetailViewModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if stockDelegate == nil {
            self.stockDelegate = self
            StockManager.shared.addDelegate(stockDelegate)
        }
        
        registerCells()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    public func getChartData(for stock: Stock) {
        IEXApiClient.shared.getChartData(for: stock) { (success, stock) in
            guard
                let stock = stock,
                let chartPoints = stock.chartPoints
                else { return }
            StockManager.shared.update(stock, using: chartPoints)
            self.stock = stock
        }
    }
}

extension StockDetailViewController: StockManagerDelegate {
    func stocksDidUpdate() {
        //TODO: Refresh views
    }
}

extension StockDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    private func registerCells() {
        tableView.register(BannerTableViewCell.nib, forCellReuseIdentifier: BannerTableViewCell.identifier)
        tableView.register(MarketMetricsTableViewCell.nib, forCellReuseIdentifier: MarketMetricsTableViewCell.identifier)
        tableView.register(DividendMetricsTableViewCell.nib, forCellReuseIdentifier: DividendMetricsTableViewCell.identifier)
        tableView.register(ModifySharesTableViewCell.nib, forCellReuseIdentifier: ModifySharesTableViewCell.identifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /// Four cells; first is Banner, second is common metrics, third Dividends, and fourth modify shares
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let first = IndexPath(row: 0, section: 0)
        let second = IndexPath(row: 1, section: 0)
        let third = IndexPath(row: 2, section: 0)
        let fourth = IndexPath(row: 3, section: 0)
        
        guard
            let bannerCell = tableView.dequeueReusableCell(withIdentifier: BannerTableViewCell.identifier, for: first) as? BannerTableViewCell,
            let marketMetricsCell = tableView.dequeueReusableCell(withIdentifier: MarketMetricsTableViewCell.identifier, for: second) as? MarketMetricsTableViewCell,
            let dividendMetricsCell = tableView.dequeueReusableCell(withIdentifier: DividendMetricsTableViewCell.identifier, for: third) as? DividendMetricsTableViewCell,
            let modifySharesCell = tableView.dequeueReusableCell(withIdentifier: ModifySharesTableViewCell.identifier, for: fourth) as? ModifySharesTableViewCell
        else {
            return UITableViewCell()
        }
        
        switch indexPath.row {
        case 0:
            DispatchQueue.main.async {
                bannerCell.set(using: self.stock)
            }
            return bannerCell
        case 1: return marketMetricsCell
        case 2: return dividendMetricsCell
        case 3: return modifySharesCell
        default: return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = UIScreen.main.bounds.height / 3
        return height
    }
    
}
