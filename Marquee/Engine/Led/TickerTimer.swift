//
//  TickerTimer.swift
//  Marquee
//
//  Created by Mark Wong on 2/10/2022.
//

import UIKit

class TickerTimer: NSObject {
    
    private var displayLink: CADisplayLink! = nil
    
    var fire: (() -> ())? = nil
    
    // Also sets the preferred frame frame rate range - essentially updating the speed
    var preferredFps: Float {
        didSet {
            self.displayLink.preferredFrameRateRange = .init(minimum: 1, maximum: 240, __preferred: 160)
        }
    }
    
    init(preferredFps: Float) {
        self.preferredFps = preferredFps
        super.init()
        initTimer()
    }
    
    func initTimer() {
        self.displayLink = CADisplayLink(target: self, selector: #selector(fireTimer))
        self.displayLink.preferredFrameRateRange = .init(minimum: 50, maximum: 60, __preferred: 60)
        self.displayLink.add(to: .current, forMode: .common)
    }
    
    @objc func fireTimer() {
        fire?()
    }
    
    func shutdownTimer() {
        fire = nil
        displayLink = nil
    }
    
    deinit {
        print("deinit")
    }
}
