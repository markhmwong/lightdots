//
//  ShimmerPreview.swift
//  Marquee
//
//  Created by Mark Wong on 15/10/2022.
//

import UIKit

class PreviewBox: UIView {

    private var backgroundArr: [[Led]] = [[]]
    
    private var foregroundArr: [[Led]] = [[]]
    
    private let pixelSize: Int = 10
    
    struct Coordinates {
        var x: Int
        var y: Int
    }
    
    private var shimmerCoordinates: [Coordinates] = []
    
    private let type: BackgroundProperties
    
    private let resolution: Resolution
    
    init(frame: CGRect, type: BackgroundProperties) {
        self.type = type
        self.resolution = LedOptions.shared.loadResolution()
        super.init(frame: frame)
//        self.translatesAutoresizingMaskIntoConstraints = false
        print("This needs to change")
        
        self.backgroundColor = UIColor.neoGray
        self.clipsToBounds = true
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        switch type {
        case .shimmer:
            let bColor = LedOptions.shared.loadShimmerBackground()
            self.backgroundColor = bColor
            self.shimmerPreview()
        case .flash:
            self.backgroundColor = UIColor.white
            self.flashPreview()
        case .solid:
            self.solidPreview(borderWidth: CGFloat(LedOptions.shared.loadBorderWidth()), borderColour: LedOptions.shared.loadBorderColor())
        case .rainbowNoise:
            self.rainbowNoisePreview()
        case .noise:
            self.noisePreview()
//        case .gradient:
//            ()
        }
        
    }
    
    /*
     MARK: Noise - refactor to effects
     */
    func noisePreview() {
        let numPixelsX: Int = Int(bounds.width /  CGFloat(pixelSize))
        let numPixelsY: Int = Int(bounds.height / CGFloat(pixelSize))

        for i in 0...numPixelsY {
            var row: [Led] = []
            for k in 0...numPixelsX {
                let point = CGPoint(x: k * pixelSize, y: i * pixelSize)
                let pixelView = Led(frame: CGRect(origin: point, size: CGSize(width: pixelSize, height: pixelSize)), color: .yellow, ledShape: .square, resolution: resolution)
                pixelView.borderColor = UIColor.black.cgColor
                pixelView.backgroundColor = UIColor.white.cgColor
                pixelView.borderWidth = 1.0
                pixelView.rainbowColor = UIColor().grayShadesRandom
                
                row.append(pixelView)
                layer.addSublayer(pixelView)
            }
            backgroundArr.append(row)
        }
        backgroundArr.removeFirst()
    }
    
    /*
     MARK: Rainbow Noise - refactor to effects
     */
    func rainbowNoisePreview() {
        let numPixelsX: Int = Int(bounds.width /  CGFloat(pixelSize))
        let numPixelsY: Int = Int(bounds.height / CGFloat(pixelSize))

        for i in 0...numPixelsY {
            var row: [Led] = []
            for k in 0...numPixelsX {
                let point = CGPoint(x: k * pixelSize, y: i * pixelSize)
                let pixelView = Led(frame: CGRect(origin: point, size: CGSize(width: pixelSize, height: pixelSize)), color: .yellow, ledShape: .square, resolution: resolution)
                pixelView.borderColor = UIColor.black.cgColor
                pixelView.backgroundColor = UIColor.white.cgColor
                pixelView.borderWidth = 1.0
                pixelView.rainbowColor = UIColor().random
                
                row.append(pixelView)
                layer.addSublayer(pixelView)
            }
            backgroundArr.append(row)
        }
        backgroundArr.removeFirst()
    }
    
    /*
     MARK: Flash
     */
    func flashPreview() {
        let numPixelsX: Int = Int(bounds.width /  CGFloat(pixelSize))
        let numPixelsY: Int = Int(bounds.height / CGFloat(pixelSize))

        for i in 0...numPixelsY {
            var row: [Led] = []
            for k in 0...numPixelsX {
                let point = CGPoint(x: k * pixelSize, y: i * pixelSize)
                let pixelView = Led(frame: CGRect(origin: point, size: CGSize(width: pixelSize, height: pixelSize)), color: .blue, ledShape: .square, resolution: resolution)
                pixelView.borderColor = UIColor.black.cgColor
                pixelView.borderWidth = 1.0
                let speed = LedOptions.shared.loadFlashSpeed()
                let colour = LedOptions.shared.loadFlashBackground()
                pixelView.backgroundColor = UIColor.white.cgColor
                pixelView.flash(color: UIColor.hexStringToUIColor(hex: colour), duration: Double(speed))
                pixelView.layoutIfNeeded()
                row.append(pixelView)
                layer.addSublayer(pixelView)
            }
            backgroundArr.append(row)
        }
        backgroundArr.removeFirst()
    }
    
    func updateFlash(color: UIColor, duration: Float) {
//        backgroundArr.removeAll()
//        self.flashPreview()
        let _ = backgroundArr.map { yLed in
            yLed.map { xLed in
                xLed.flash(color: color, duration: Double(duration))
            }
        }
    }
    
    /*
     MARK: Shimmer
     */
    func shimmerPreview(_ pixelSize: Int = 10) {

        let numPixelsX: Int = Int(bounds.width /  CGFloat(pixelSize))
        let numPixelsY: Int = Int(bounds.height / CGFloat(pixelSize))

        for i in 0...numPixelsY {
            var row: [Led] = []
            for k in 0...numPixelsX {
                let point = CGPoint(x: k * pixelSize, y: i * pixelSize)
                let pixelView = Led(frame: CGRect(origin: point, size: CGSize(width: pixelSize, height: pixelSize)), color: .blue, ledShape: .square, resolution: resolution)
                pixelView.borderColor = UIColor.black.cgColor
                pixelView.backgroundColor = UIColor.clear.cgColor
                pixelView.borderWidth = 1.0
                let state = Int.random(in: 0...1) == 0 ? true : false
                if state {
                    shimmerCoordinates.append(Coordinates(x: k, y: i))
                    let fColor = LedOptions.shared.loadShimmerForeground()
                    pixelView.shimmerColor = fColor
                }
                row.append(pixelView)
                pixelView.addSublayer(pixelView)
            }
            backgroundArr.append(row)
        }
        backgroundArr.removeFirst()
    }
    
    func solidPreview(_ pixelSize: Int = 10, borderWidth: CGFloat = 1.0, borderColour: UIColor = UIColor.black) {
        let numPixelsX: Int = Int(bounds.width /  CGFloat(pixelSize))
        let numPixelsY: Int = Int(bounds.height / CGFloat(pixelSize))

        for i in 0...numPixelsY {
            var row: [Led] = []
            for k in 0...numPixelsX {
                let point = CGPoint(x: k * pixelSize, y: i * pixelSize)
                let pixelView = Led(frame: CGRect(origin: point, size: CGSize(width: pixelSize, height: pixelSize)), color: .blue, ledShape: .square, resolution: resolution)
                pixelView.borderColor = borderColour.cgColor
                pixelView.backgroundColor = UIColor.clear.cgColor
                pixelView.borderWidth = borderWidth
                row.append(pixelView)
                layer.addSublayer(pixelView)
            }
            backgroundArr.append(row)
        }
        backgroundArr.removeFirst()
    }
    
    func backgroundReset(_ color: UIColor) {
        for c in shimmerCoordinates {
            backgroundArr[c.y][c.x].backgroundColor = UIColor.clear.cgColor
            backgroundArr[c.y][c.x].shimmerColor = color
        }
    }
    
    func borderWidthPreview(_ width: CGFloat) {
        let _ = backgroundArr.map { yLed in
            yLed.map { xLed in
                DispatchQueue.main.async {
                    xLed.borderWidth = width
                }
                
            }
        }
    }
    
    func borderColourPreview(_ colour: UIColor) {
        let _ = backgroundArr.map { yLed in
            yLed.map { xLed in
                DispatchQueue.main.async {
                    xLed.borderColor = colour.cgColor
                }
            }
        }
    }
}
