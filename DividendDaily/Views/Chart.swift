//
//  Chart.swift
//  DividendDaily
//
//  Created by Christopher Moore on 8/22/18.
//  Copyright © 2018 Christopher Moore. All rights reserved.
//

import Foundation
import UIKit

class Chart: UIView {
    
    /// rough estimates for layout margins of a Chart
    private struct Margins {
        static let right: CGFloat = 10
        static let left: CGFloat = 10
        static let top: CGFloat = 10
        static let bottom: CGFloat = 5
    }
    
    private var chartPoints: [ChartPoint]!

    
    required convenience init(frame: CGRect, with chartPoints: [ChartPoint]) {
        self.init(frame: frame)
        self.chartPoints = chartPoints
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func setup(with points: [ChartPoint]) {
        self.chartPoints = points
    }
    
    // Begin drawing
    override func draw(_ rect: CGRect) {
        guard chartPoints != nil,
            !chartPoints.isEmpty else { return }
        
        let yLowyHigh = findYRange()
//        let range = yLowyHigh.max - yLowyHigh.min
        let maxYOffset = rect.maxY - 15
        let graphPath = UIBezierPath()
        graphPath.move(to: CGPoint(x: 20,
                                   y: maxYOffset * (CGFloat((yLowyHigh.max - chartPoints.first!.close)) / CGFloat((yLowyHigh.max - yLowyHigh.min))) + 10 ))
        for i in 0..<chartPoints.count {
            
            let xOffset = (rect.maxX * (CGFloat(CGFloat(1)/CGFloat(chartPoints.count)))) / 2
            let yHighAdjusted = yLowyHigh.max
            
            
            let point = chartPoints[i]
            let newPoint = CGPoint(
                x: rect.maxX * (CGFloat(CGFloat(i)/CGFloat(chartPoints.count))) + xOffset,
                y: maxYOffset * (CGFloat((yLowyHigh.max - point.close)) / CGFloat((yLowyHigh.max - yLowyHigh.min))) + 10)
//                y: rect.midY * CGFloat((point.close / yLowyHigh.max)))
            
            let circle = UIBezierPath(ovalIn: CGRect(origin: CGPoint(x: newPoint.x - 3, y: newPoint.y - 3), size: CGSize(width: 6, height: 6)))
            
            UIColor.black.setFill()
            circle.fill()
            graphPath.addLine(to: newPoint)
        }
        UIColor.black.setStroke()
        graphPath.lineWidth = 3.0
        graphPath.stroke()
        
    }
    
    private func findYRange() -> (min: Double, max: Double) {
        var min: Double = 0
        var max: Double = 0
        
        let temp = chartPoints!.sorted { (first, second) -> Bool in
            first.close < second.close
        }
        min = temp.first!.close
        max = temp.last!.close
        
        return (min, max)
    }
    
}
