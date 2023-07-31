//
//  Led.swift
//  Marquee
//
//  Created by Mark Wong on 29/9/2022.
//

import UIKit

protocol LedProtocol {
    
    var ledState: Bool { get }
    
    func turnOn(_ state: Bool)
    
}

// MARK: To do
//  add icon
class Led: CALayer, LedProtocol {
    
    var shimmerColor: UIColor? = nil {
        didSet {
            guard let shimmerColor = shimmerColor else { return }
            let state = Int.random(in: 0...1) == 0 ? true : false
            if state {
                self.shimmerForeground(color: shimmerColor)
            }
        }
    }
    
    var grayScaleNoise: UIColor? = nil {
        didSet {
            guard let grayScaleNoise = grayScaleNoise else { return }
            self.grayscaleRandomisation(color: grayScaleNoise)
        }
    }
    
    var rainbowColor: UIColor? = nil {
        didSet {
            guard let rainbowColor = rainbowColor else { return }
            self.rainbowRandomisation(color: rainbowColor)
        }
    }
    
//    private var coordinate: LedCoordinate! = nil
    
    var color: UIColor? = nil {
        didSet {
            self.backgroundColor = color?.cgColor
        }
    }
    
    var animateBg: Bool = false
    
    /** Represents the memory address of a pixel. */
//    private var pixelPointer: UnsafePointer<UInt8> {
//        didSet {
//            color = UIColor.yellow
//        }
//    }
    
    internal var ledState: Bool
    
    internal var ledShape: LedShape
    
    private var resolution: Resolution

    override init(layer: Any) {
        self.ledShape = .circle
        self.ledState = false
        self.resolution = .sd
        super.init(layer: layer)
    }
    
    init(frame: CGRect, color: UIColor, ledShape: LedShape, resolution: Resolution) {
        self.ledShape = ledShape
        self.ledState = false
        self.resolution = resolution
        super.init(layer: frame)
        self.frame = frame
        self.color = color
        self.changeLedShape(ledShape: ledShape)
        self.borderWidth = resolution.pixelBorderWidth
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func turnOn(_ state: Bool) {
        self.ledState = state
    }
    
//    func position() -> LedCoordinate {
//        return coordinate
//    }
    
    private func changeLedShape(ledShape: LedShape) {
        self.borderColor = UIColor.gray.cgColor

        switch ledShape {
        case .circle:
            self.cornerRadius = bounds.height / 2
            
        case .square:
            //default
            self.cornerRadius = 1.0
        case .diamond:
            self.cornerRadius = bounds.height * 0.7
            self.borderWidth = 0
        }
//        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.repeat, .autoreverse, .allowAnimatedContent]) {
//            self.layer.borderColor = UIColor.black.cgColor
//        }
//
//        self.animateBorderWidth(toValue: 1, duration: 0.35)
    }
    
    func animateBorderWidth(toValue: CGFloat, duration: Double = 0.3) {
        let animation = CABasicAnimation(keyPath: "borderWidth")
        animation.fromValue = borderWidth
        animation.toValue = toValue
        animation.duration = duration
        animation.autoreverses = true
        animation.repeatCount = 99999
        add(animation, forKey: "Width")
        borderWidth = toValue
    }
    
    private func shimmerForeground(color: UIColor) {
        self.layoutIfNeeded()
        let duration = Int.random(in: 2...3)
        let delay = Int.random(in: 1...2)
        DispatchQueue.main.async {
            UIView.animate(withDuration: TimeInterval(duration), delay: TimeInterval(delay), options: [.repeat, .autoreverse, .allowAnimatedContent]) {
                self.backgroundColor = color.cgColor
                self.layoutIfNeeded()
            }
        }
    }
    
    private func rainbowRandomisation(color: UIColor) {
        self.layoutIfNeeded()
        let duration = Int.random(in: 1...20)
        let delay = Int.random(in: 1...10)
        let d = Double(duration) / Double(10.0)
        self.backgroundColor = UIColor.white.cgColor
        DispatchQueue.main.async {
            UIView.animate(withDuration: d, delay: Double(delay) / 10, options: [.repeat, .autoreverse, .allowAnimatedContent]) {
                self.backgroundColor = color.cgColor
                self.layoutIfNeeded()
            }
        }
    }
    
    private func grayscaleRandomisation(color: UIColor) {
        self.layoutIfNeeded()
        let duration = Int.random(in: 1...20)
        let delay = Int.random(in: 1...10)
        let d = Double(duration) / Double(10.0)
        DispatchQueue.main.async {
            UIView.animate(withDuration: d, delay: Double(delay) / 10, options: [.repeat, .autoreverse, .allowAnimatedContent]) {
                self.backgroundColor = color.cgColor
                self.layoutIfNeeded()
            }
        }
    }
    
    func flash(color: UIColor, duration: Double) {
        self.backgroundColor = UIColor.white.cgColor
//        self.layoutIfNeeded()
        DispatchQueue.main.async {
            UIView.animate(withDuration: duration, delay: 0.01, options: [.repeat, .autoreverse]) {
                self.backgroundColor = color.cgColor
                self.layoutIfNeeded()
            }
        }
    }
}
