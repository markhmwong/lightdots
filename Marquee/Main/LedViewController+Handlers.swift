//
//  LedViewController+Handlers.swift
//  Marquee
//
//  Created by Mark Wong on 11/11/2022.
//

import Foundation

extension LedViewController {
    @objc func handlePro() {
        coordinator.showPro()
    }
    
    @objc func handleOptions() {
        coordinator.showOptions()
    }
    
    @objc func handleReset() {
        self.tickerView.reset()
    }
    
    @objc func handleAbout() {
        coordinator.showAbout()
    }
}
