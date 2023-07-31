//
//  StaticLedTickerView+B.swift
//  Ledify
//
//  Created by Mark Wong on 3/3/2023.
//

import UIKit
import MetalKit

class LEDGridView: UIView {
    
    var numRows: Int
    var numCols: Int
    
    private var colorMap: [[UIColor?]]
    
    private var bgLayers: [[CALayer]] = []
    
    private var fgLayers: [[CALayer]] = []

    private var numLedRows: Int = 0
    
    private var numLedHeight: Int = 0
    
    private var ledWidth: CGFloat = 0.0
    
    private var ledHeight: CGFloat = 0.0
    
    // GPU
    private var ledBuffer: MTLBuffer!
    
    private var pipelineState: MTLComputePipelineState!
    
    private var commandQueue: MTLCommandQueue!
    
    init(frame: CGRect, numRows: Int, numCols: Int, colorMap: [[UIColor?]]) {
        self.colorMap = colorMap
        self.numRows = numRows
        self.numCols = numCols
        super.init(frame: frame)
        self.ledProperties()
        self.setupLEDGrid()
//        self.setupMetal()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func ledProperties() {
        // led size
        self.ledWidth = 6.0
        self.ledHeight = self.ledWidth
        
        // number of leds needed to fill the screen
        // rows
        self.numLedRows = Int(ceil(self.frame.size.width / self.ledWidth))
        // cols
        self.numLedHeight = Int(ceil(self.frame.size.height / self.ledHeight))

        print(numLedRows, numLedHeight)
    }
    
    //draw grid
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        print("draw")
//        self.debugDrawUsingForeground()
//        self.debugDrawWithCALayerObjects()
        self.debugDrawWithLEDObjects()
    }
    
    private func setupLEDGrid() {
        print("setup")
        backgroundColor = .yellow

        for row in 0..<numLedHeight {
            var bgRow: [CALayer] = []
            var fgRow: [CALayer] = []
            for col in 0..<numLedRows {
                let bgLed = CALayer()
                bgLed.frame = CGRect(x: CGFloat(col) * self.ledWidth,
                                        y: CGFloat(row) * self.ledHeight,
                                        width: self.ledWidth,
                                        height: self.ledHeight)

                bgLed.cornerRadius = 0
                bgLed.borderWidth = 1.0
                bgLed.borderColor = UIColor.white.cgColor
                bgLed.backgroundColor = UIColor.black.cgColor
//                layer.addSublayer(bgLed)
                bgRow.append(bgLed)
                
                let fgLed = CALayer()
                fgLed.frame = CGRect(x: CGFloat(col) * self.ledWidth,
                                        y: CGFloat(row) * self.ledHeight,
                                        width: self.ledWidth,
                                        height: self.ledHeight)

                fgLed.cornerRadius = 0
                fgLed.borderWidth = 1.0
                fgLed.borderColor = UIColor.white.cgColor
                fgLed.backgroundColor = UIColor.orange.cgColor
//                layer.addSublayer(fgLed)
                fgRow.append(fgLed)
            }
            bgLayers.append(bgRow)
            fgLayers.append(fgRow)
        }
    }
    
    func setLEDColor(row: Int, col: Int, color: UIColor) {
        bgLayers[row][col].backgroundColor = color.cgColor
    }
    
    func feedMappingToGrid(colorMapYIndex: Int, counter: Int) {
//        assert(colorMap.count < foregroundGrid.count, "Colormap should be smaller than the provided canvas. Might be something wrong with the cleanup method in AsciiEngine")
        
//        let centerOffset = self.calculateCenterOffset()
        let centerOffset = 0
        let _ = colorMap.enumerated().map { (y, e) in
            let maxX = self.fgLayers[y].count - 1
            // replace text with color
            // works with clean up pass at +6
            self.fgLayers[y + centerOffset][maxX].backgroundColor = colorMap[y][counter]?.cgColor
        }
    }
    
    private func setupMetal() {
         guard let device = MTLCreateSystemDefaultDevice() else {
             fatalError("Metal is not supported on this device")
         }

         let library = device.makeDefaultLibrary()!
         let kernel = library.makeFunction(name: "setLEDColors")!
         pipelineState = try! device.makeComputePipelineState(function: kernel)
         commandQueue = device.makeCommandQueue()!

         let numLEDs = numRows * numCols
         let ledSize = MemoryLayout<simd_float4>.stride
         let ledBufferSize = ledSize * numLEDs
         ledBuffer = device.makeBuffer(length: ledBufferSize, options: [])!
     }
}

/*
 
 Test
 
 */
extension LEDGridView {
    
//    func runTest() {
//        shiftx = foregroundGrid[0].count - 1
//        for j in 40..<50 {
//
//            for i in 0..<foregroundGrid.count {
//                self.foregroundGrid[i][j].backgroundColor = UIColor.red.cgColor
//            }
//        }
//        shiftx = 0
//    }
    
    // draws the converted ascii string to the grid
    func debugDrawWithCALayerObjects() {
        var x = 0
        var y = 0

//        print(colorMap.count, colorMap[0].count, foregroundGrid.count, foregroundGrid[0].count)

        while y < colorMap.count {

                while x < colorMap[y].count {
                    
                    let rect = CGRect(origin: CGPoint(x: Int(ledHeight) * x, y: Int(ledWidth) * y), size: CGSize(width: Int(ledWidth), height: Int(ledHeight)))
                    let led = CALayer()
                    led.frame = CGRect(x: CGFloat(x) * self.ledWidth,
                                            y: CGFloat(y) * self.ledHeight,
                                            width: self.ledWidth,
                                            height: self.ledHeight)
                    led.borderColor = UIColor.blue.cgColor
                    led.borderWidth = 1.0
                    led.backgroundColor = colorMap[y][x]?.cgColor
                    print(colorMap[y][x])
                    layer.addSublayer(led)
                    x = x + 1
                }
            print()
            x = 0
            y = y + 1
        }
    }
    
    func debugDrawWithLEDObjects() {
        var x = 0
        var y = 0

//        print(colorMap.count, colorMap[0].count, foregroundGrid.count, foregroundGrid[0].count)
        let start = CFAbsoluteTimeGetCurrent()
        while y < colorMap.count {

                while x < colorMap[y].count {
                    
                    let rect = CGRect(origin: CGPoint(x: Int(ledHeight) * x, y: Int(ledWidth) * y), size: CGSize(width: Int(ledWidth), height: Int(ledHeight)))
                    let led = Led(frame: rect, color: colorMap[y][x] ?? .cyan, ledShape: .square, resolution: .sd)
                    led.borderColor = UIColor.blue.cgColor
                    led.borderWidth = 1.0
                    led.backgroundColor = colorMap[y][x]?.cgColor
//                    print(colorMap[y][x])
                    layer.addSublayer(led)
                    x = x + 1
                }
            print()
            x = 0
            y = y + 1
        }
        let diff = CFAbsoluteTimeGetCurrent() - start
        print(diff)
    }
    
    // draws the converted ascii string to the grid
    func debugDrawUsingForeground() {
        var x = 0
        var y = 0
        
//        print(colorMap.count, colorMap[0].count, fgLayers.count, fgLayers[0].count)
        while y < colorMap.count {
                while x < colorMap[y].count {
                    if x < fgLayers[y].count {
                        fgLayers[y][x].backgroundColor = colorMap[y][x]?.cgColor
                        x = x + 1
                    } else {
                        break
                    }
                    
                }

            x = 0
            y = y + 1
        }
    }
}

