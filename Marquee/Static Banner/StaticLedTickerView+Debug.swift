//
//  StaticLedTickerView+Debug.swift
//  Ledify
//
//  Created by Mark Wong on 8/3/2023.
//

import UIKit

/*
 
 Test
 
 */
extension StaticLedTickerView {
    
    func runTest() {
        shiftx = foregroundGrid[0].count - 1
        for j in 40..<50 {

            for i in 0..<foregroundGrid.count {
                self.foregroundGrid[i][j].backgroundColor = UIColor.red.cgColor
            }
        }
        shiftx = 0
    }
    
    // draws the converted ascii string to the grid
    func debugDrawWithNewLedObjects() {
        var x = 0
        var y = 0
        
//        print(colorMap.count, colorMap[0].count, foregroundGrid.count, foregroundGrid[0].count)
        
        while y < colorMap.count {

                while x < colorMap[y].count {
                    let rect = CGRect(origin: CGPoint(x: Int(ledSize.height) * x, y: Int(ledSize.width) * y), size: CGSize(width: Int(ledSize.width), height: Int(ledSize.height)))
                    let led = Led(frame: rect, color: .white, ledShape: ledShape, resolution: resolution)
                    led.borderColor = UIColor.blue.cgColor
                    led.borderWidth = 1.0
                    led.color = colorMap[y][x]
                    layer.addSublayer(led)
                    x = x + 1
                }

            x = 0
            y = y + 1
        }
    }
    
    // draws the converted ascii string to the grid
    func debugDrawUsingForeground() {
        var x = 0
        var y = 0
        
        print(colorMap.count, colorMap[0].count, foregroundGrid.count, foregroundGrid[0].count)
        while y < colorMap.count {
                while x < colorMap[y].count {
                    foregroundGrid[y][x].backgroundColor = colorMap[y][x]?.cgColor
                    x = x + 1
                }

            x = 0
            y = y + 1
        }
    }
}
