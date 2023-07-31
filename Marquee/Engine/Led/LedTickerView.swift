  //
//  TickerView.swift
//  Marquee
//
//  Created by Mark Wong on 16/9/2022.
//

import UIKit

// represents the digitised/LED ticker
final class LedTickerView: UIView {
 
    // mapping of the text
    private var colorMap: [[UIColor?]]
    
    // A reference to the grid holding the text that gets scrolled across the screen
    // both the foreground and background are the same and layered on top of each other
    private var foregroundGrid: [[Led]] = [[]]
    
    // a reference to the established led lights
    private var backgroundGrid: [[Led]] = [[]]
    
    private var shiftx: Int = 0
    
    // each size of the pixel
    private var ledSize: CGSize
    
    private var resolution: Resolution
    
    private var ledShape: LedShape
    
    //timer
    var timer: TickerTimer?
    
    private var colorMapXCount = 0
    
    private var borderColour: UIColor
    
    private var borderWidth: CGFloat
    
    private var gpuRenderer: GpuRenderer! = nil
    
    // add new parameter that can describe the characteristics of the leds
    init(frame: CGRect, colorMapping: [[UIColor?]], resolution: Resolution, ledShape: LedShape, borderWidth: CGFloat, borderColour: UIColor, orientation: Orientation = .landscape) {
        self.borderColour = borderColour
        self.borderWidth = borderWidth
        self.colorMap = colorMapping // text mapping
        self.resolution = resolution
        self.ledSize = resolution.pixelSize
        self.ledShape = ledShape
        super.init(frame: frame)
        self.initialiseCanvas(orientation: orientation)
        self.initTimer()
        isOpaque = false
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadBackground(view led: Led) {
        let bgType = LedOptions.shared.loadSelectedBackground()
        
        switch bgType {
        case .solid:
            let hex = LedOptions.shared.loadSolidBackgroundColour()
            led.backgroundColor = UIColor.hexStringToUIColor(hex: hex).cgColor
        case .noise:
            led.grayScaleNoise = UIColor().grayShadesRandom
        case .rainbowNoise:
            led.rainbowColor = UIColor().random
        case .shimmer:
            let fColor = LedOptions.shared.loadShimmerForeground()
            let bColor = LedOptions.shared.loadShimmerBackground()
            led.shimmerColor = fColor
            led.backgroundColor = bColor.cgColor
        case .flash:
            let duration = LedOptions.shared.loadFlashSpeed()
            let bgHex = LedOptions.shared.loadFlashBackground()
            led.backgroundColor = UIColor.white.cgColor
            led.flash(color: UIColor.hexStringToUIColor(hex: bgHex), duration: TimeInterval(duration))
//        case .gradient:
//            ()
        }
        
    }
    
    func initTimer() {
        let speed = LedOptions.shared.loadScrollSpeed()
        timer = TickerTimer(preferredFps: speed)
        timer?.fire = {
            self.shiftLeft()
            // add gpu function
            
        }
    }
    
    enum Orientation {
        case landscape
        case portrait
    }
    
    func updateSpeed(speed: Float) {
        timer?.preferredFps = speed
    }
    
    // led grid
    func initialiseCanvas(orientation: Orientation = .landscape) {
        // swap the width/height in the comments to enable native landscape
        //in combination with this reversal, a transform is also applied on this view
        
        var xLeds: Int = 0
        var yLeds: Int = 0
        
        switch orientation {
        case .landscape:
            xLeds = Int(self.frame.size.height / ledSize.height)
            yLeds = Int(self.frame.size.width / ledSize.width)
        case .portrait:
            yLeds = Int(self.frame.size.height / ledSize.height)
            xLeds = Int(self.frame.size.width / ledSize.width)
        }
        
        var x = 0
        var y = 0
        
        while y <= yLeds {
            var bgRow: [Led] = []
            var fgRow: [Led] = []

            while x <= xLeds {
                let rect = CGRect(origin: CGPoint(x: Int(ledSize.height) * x, y: Int(ledSize.width) * y), size: CGSize(width: Int(ledSize.width), height: Int(ledSize.height)))
                print(rect)
                let bgLed = Led(frame: rect, color: .red, ledShape: ledShape, resolution: resolution)
                bgLed.borderWidth = borderWidth
                bgLed.borderColor = borderColour.cgColor
                bgLed.backgroundColor = UIColor(red: 32 / 255, green: 42 / 255, blue: 68 / 255, alpha: 1.0).cgColor
                self.layer.addSublayer(bgLed)
//                loadBackground(view: bgLed)
                bgRow.append(bgLed)
                
                let fgLed = Led(frame: rect, color: .clear, ledShape: ledShape, resolution: resolution)
//                led.layer.borderColor = UIColor.black.withAlphaComponent(1.0).cgColor
//                led.layer.borderWidth = resolution.pixelBorderWidth
                self.layer.addSublayer(fgLed)
                fgRow.append(fgLed)
                x = x + 1
            }
            backgroundGrid.append(bgRow)
            foregroundGrid.append(fgRow)
            x = 0
            y = y + 1
        }
        
        y = 0; x = 0
        
//        while y <= yLeds {
//            var row: [Led] = []
//            while x <= xLeds {
//                let rect = CGRect(origin: CGPoint(x: Int(ledSize.height) * x, y: Int(ledSize.width) * y), size: CGSize(width: Int(ledSize.width), height: Int(ledSize.height)))
//
//                let fgLed = Led(frame: rect, color: .clear, ledShape: ledShape, resolution: resolution)
////                led.layer.borderColor = UIColor.black.withAlphaComponent(1.0).cgColor
////                led.layer.borderWidth = resolution.pixelBorderWidth
//                addSubview(fgLed)
//                row.append(fgLed)
//
//                x = x + 1
//            }
//            foregroundGrid.append(row)
//            x = 0
//            y = y + 1
//        }

        // fix this. because we've initialised the array as [[]] there's an empty array at index 0
//        print("to be removed")
        backgroundGrid.removeFirst()
        foregroundGrid.removeFirst()
        
//        self.runTest()
    }
    
    
    
    //draw grid
    override func draw(_ rect: CGRect) {
        super.draw(rect)
//        sliceToDraw(rowLength: 1)
//        self.debugDraw()
    }
    
    func feedMappingToGrid(colorMapYIndex: Int, counter: Int) {
        assert(colorMap.count < foregroundGrid.count, "Colormap should be smaller than the provided canvas. Might be something wrong with the cleanup method in AsciiEngine")
        
        let centerOffset = self.calculateCenterOffset() // y center

        let _ = colorMap.enumerated().map { (y, e) in
            let maxX = self.foregroundGrid[y].count - 1
            // replace text with color
            // works with clean up pass at +6
            self.foregroundGrid[y + centerOffset][maxX].color = colorMap[y][counter]
        }
    }
    
    private func calculateCenterOffset() -> Int {
        let midY = foregroundGrid.count / 2
        let midColorMap = colorMap.count / 2
        
        return midY - midColorMap < 0 ? 0 : midY - midColorMap
    }
    
    private var frontEnd: Int = 0
    private var colorMapYIndex: Int = 0
    private var yIndex: Int = 0
    
    // Acting like a conveyor belt, the colormapping is fed into the foreground grid. The function will operate at 60hz, and swap x indexes each frame to update what is seen to the user
    @objc func shiftLeft() {
        // loop the message or grab the next column in array
        if colorMapXCount == colorMap[0].count - 1 {
            colorMapXCount = 0
            if SubscriptionService.shared.proStatus() {
                HapticFeedback.shared.success()
            }
        } else {
            colorMapXCount = colorMapXCount + 1
        }
    
        let _ = self.foregroundGrid.enumerated().map { (y, yLed) in
            yLed.enumerated().map { (x, xLed) in
                if x <= self.foregroundGrid[y].count - 1 && x >= 1 {
                    // the actual 'shifting' of the foreground grid. done by swapping two elements and then updating the frame
                    self.foregroundGrid[y][x - 1].color = self.foregroundGrid[y][x].color
                }
            }
        }
        
        self.feedMappingToGrid(colorMapYIndex: self.colorMapYIndex, counter: self.colorMapXCount)
    }
    
    func reset() {
        self.colorMapXCount = 0
    }
    
    
    deinit {
        timer?.shutdownTimer()
        timer = nil
    }
}

/*
 
 Test
 
 */
extension LedTickerView {
    
    func runTest() {
        shiftx = foregroundGrid[0].count - 1
        for j in 40..<50 {

            for i in 0..<foregroundGrid.count {
                self.foregroundGrid[i][j].backgroundColor = UIColor.red.cgColor
            }
        }
        shiftx = 0
    }
    
    func debugDraw() {
        var x = 0
        var y = 0
        
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
}


