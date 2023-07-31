//
//  StaticLedView.swift
//  Ledify
//
//  Created by Mark Wong on 2/1/2023.
//

import UIKit
import MetalKit

final class StaticLedTickerView: UIView {
 
    // mapping of the text
    var colorMap: [[UIColor?]]
    
    // A reference to the grid holding the text that gets scrolled across the screen
    // both the foreground and background are the same and layered on top of each other
    var foregroundGrid: [[Led]] = [[]]
    
    // a reference to the established led lights
    private var backgroundGrid: [[Led]] = [[]]
    
    var shiftx: Int = 0
    
    // each size of the pixel
    var ledSize: CGSize
    
    var resolution: Resolution
    
    var ledShape: LedShape
    
    //timer
    var timer: TickerTimer?
    
    private var colorMapXCount = 0
    
    private var borderColour: UIColor
    
    private var borderWidth: CGFloat
    
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
        backgroundColor = .yellow
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
            self.runTicker()
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
        backgroundColor = UIColor.cyan
        let start = CFAbsoluteTimeGetCurrent()
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
                let bgLed = Led(frame: rect, color: .red, ledShape: ledShape, resolution: resolution)
                bgLed.frame = rect
                bgLed.borderWidth = 1//borderWidth
                bgLed.borderColor = UIColor.orange.cgColor//borderColour.cgColor
                bgLed.backgroundColor = UIColor(red: 32 / 255, green: 42 / 255, blue: 68 / 255, alpha: 1.0).cgColor
                self.layer.addSublayer(bgLed)
                loadBackground(view: bgLed)
                bgRow.append(bgLed)
                
                let fgLed = Led(frame: rect, color: .clear, ledShape: ledShape, resolution: resolution)
                fgLed.frame = rect
//                fgLed.borderColor = UIColor.black.withAlphaComponent(1.0).cgColor
//                led.layer.borderWidth = resolution.pixelBorderWidth
                layer.addSublayer(fgLed)
                fgRow.append(fgLed)
                x = x + 1
            }
            backgroundGrid.append(bgRow)
            foregroundGrid.append(fgRow)
            
            
            x = 0
            y = y + 1
        }
        
        

        // fix this. because we've initialised the array as [[]] there's an empty array at index 0
//        print("to be removed")
        backgroundGrid.removeFirst()
        foregroundGrid.removeFirst()
        let diff = CFAbsoluteTimeGetCurrent() - start
        print(diff)
//        self.runTest()
        
        // gpu stuff
        let device = MTLCreateSystemDefaultDevice()!
        // Create a command queue
        let commandQueue = device.makeCommandQueue()!
        let textureHeight = colorMap[0].count - 1
        let textureWidth = colorMap.count - 1
        print(textureHeight, textureWidth)
        // Create a 2D array of MTLTextures
        let textureDescriptor = MTLTextureDescriptor()
        textureDescriptor.textureType = .type2D
        textureDescriptor.pixelFormat = .rgba8Unorm
        textureDescriptor.width = textureWidth
        textureDescriptor.height = textureHeight
        let texture = device.makeTexture(descriptor: textureDescriptor)!

        // Allocate memory for a buffer to hold the pixel data for the texture
        let pixelDataSize = textureWidth * textureHeight * 4 // 4 bytes per pixel
        let pixelData = UnsafeMutableRawPointer.allocate(byteCount: pixelDataSize, alignment: 1)

        // Loop through your CALayer grid and copy the contents of each layer into the texture
        for row in 0..<textureHeight {
            for col in 0..<textureWidth {
                print(row, col)
                let layer = colorMap[col][row] ?? .neoGray// get the layer at [row][col]
//                let color = layer// get the color data for the layer
                let byteOffset = (row * textureWidth + col) * 4 // calculate the byte offset for this pixel in the texture

                pixelData.storeBytes(of: UInt32.colorToUInt32(layer), toByteOffset: byteOffset, as: UInt32.self)
            }
        }
        
        // Create a new buffer to hold the texture data
        let bufferLength = texture.width * texture.height * MemoryLayout<UInt32>.stride
        let buffer = device.makeBuffer(length: bufferLength, options: [])

        // Copy the texture data into the buffer
        texture.getBytes(buffer!.contents(), bytesPerRow: texture.width * MemoryLayout<UInt32>.stride, from: MTLRegionMake2D(0, 0, texture.width, texture.height), mipmapLevel: 0)
        
        // Iterate over the CALayers and update them with the texture data
//        for y in 0..<foregroundGrid.count {
//            for x in 0..<foregroundGrid[y].count {
//                let index = y * texture.width + x
//                let colorValue = buffer?.contents().assumingMemoryBound(to: UInt32.self)[index]
//                let color = UIColor(red: CGFloat((colorValue >> 16) & 0xFF) / 255.0, green: CGFloat((colorValue >> 8) & 0xFF) / 255.0, blue: CGFloat(colorValue & 0xFF) / 255.0, alpha: CGFloat((colorValue >> 24) & 0xFF) / 255.0)
//                calayerGrid[y][x].backgroundColor = color.cgColor
//            }
//        }
        
    }
    


    //draw grid
    override func draw(_ rect: CGRect) {
        super.draw(rect)
//        self.debugDrawUsingForeground()
        self.debugDrawWithNewLedObjects()
//        self.drawWithMTLTexture()
    }
    
    func drawWithMTLTexture() {
        let device = MTLCreateSystemDefaultDevice()!
        // Create a new Metal texture with the same size and format as your CALayer grid
        let textureWidth = colorMap[0].count
        let textureHeight = colorMap.count
        let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .rgba8Unorm,
                                                                         width: textureWidth,
                                                                         height: textureHeight,
                                                                         mipmapped: false)
        let texture = device.makeTexture(descriptor: textureDescriptor)!
        // Allocate memory for a buffer to hold the pixel data for the texture
        let pixelDataSize = textureWidth * textureHeight * 4 // 4 bytes per pixel
        let pixelData = UnsafeMutableRawPointer.allocate(byteCount: pixelDataSize, alignment: 1)
        // Loop through your CALayer grid and copy the contents of each layer into the texture
        for row in 0..<textureHeight {
            for col in 0..<textureWidth {
//                let layer = // get the layer at [row][col]
                let color = colorMap[row][col]// get the color data for the layer
                let byteOffset = (row * textureWidth + col) * 4 // calculate the byte offset for this pixel in the texture
                let color32 = UInt32.colorToUInt32(color!)
                pixelData.storeBytes(of: color32, toByteOffset: byteOffset, as: UInt32.self)
            }
        }
        
        // Copy the pixel data into the texture
        let region = MTLRegionMake2D(0, 0, textureWidth, textureHeight)
        let bytesPerRow = textureWidth * 4 // 4 bytes per pixel
        texture.replace(region: region, mipmapLevel: 0, withBytes: pixelData, bytesPerRow: bytesPerRow)

        // Deallocate the memory for the pixel data buffer
        pixelData.deallocate()
    }
    
    func feedMappingToGrid(colorMapYIndex: Int, counter: Int) {
        assert(colorMap.count < foregroundGrid.count, "Colormap should be smaller than the provided canvas. Might be something wrong with the cleanup method in AsciiEngine")
        
        let centerOffset = self.calculateCenterOffset()

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
    // left to right
    // right to left
    // top to bottom
    @objc func runTicker() {
        
    }
    
    func reset() {
        self.colorMapXCount = 0
    }
    
    
    deinit {
        timer?.shutdownTimer()
        timer = nil
    }
}


