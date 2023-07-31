//
//  TextSize.swift
//  Marquee
//
//  Created by Mark Wong on 22/10/2022.
//

import Foundation

enum TextSize: Int, CaseIterable {
    case grape
    case mandarin
    case mango
    case melon
    
    var str: String {
        switch self {
        case .grape:
            return "low"
        case .mandarin:
            return "medium"
        case .mango:
            return "high"
        case .melon:
            return "blue skies"
        }
    }
    
    func fontSize(resolution: Resolution) -> CGFloat {
        switch self {
        case .grape:
            return resolution.maxFontSize * 0.6
            // 3 - sd
            // - hd
            // - super hd
        case .mandarin:
            return resolution.maxFontSize * 0.7
            // 4 - sd
            // - hd
            // - super hd
        case .mango:
            return resolution.maxFontSize * 0.9
            // 6 - sd
            // - hd
            // - super hd
        case .melon:
            return resolution.maxFontSize
            // 8 - sd
            // - hd
            // - super hd
        }
    }
    
    
    var supportedResolutions: [Resolution] {
        switch self {
        case .mandarin:
            return [Resolution.sd, Resolution.hd, Resolution.superhd]
        case .melon:
            return [Resolution.sd, Resolution.hd, Resolution.superhd]
        case .mango:
            return [Resolution.sd, Resolution.hd, Resolution.superhd]
        case .grape:
            return [Resolution.sd, Resolution.hd, Resolution.superhd]
        }
    }
}
