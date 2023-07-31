//
//  Resolution.swift
//  Marquee
//
//  Created by Mark Wong on 21/10/2022.
//

import Foundation

enum Resolution: Int {
    case sd
    case hd
    case superhd
    
    var pixelSize: CGSize {
        switch self {
        case .sd:
            #if DEBUG
            return CGSize(width: 6.0, height: 6.0)
            #else
            return CGSize(width: 14.0, height: 14.0)
            #endif
        case .hd:
            return CGSize(width: 9.0, height: 9.0)
        case .superhd:
            return CGSize(width: 8.0, height: 8.0)
        }
    }
    
    var name: String {
        switch self {
        case .sd:
            return "SD"
        case .hd:
            return "HD"
        case .superhd:
            return "SHD"
        }
    }
    
    var maxFontSize: CGFloat {
        switch self {
        case .sd:
            return 6.0
        case .hd:
            return 9.5
        case .superhd:
            return 14.0
        }
    }
    
    
    var pixelBorderWidth: CGFloat {
        switch self {
        case .sd:
            return 0.7
        case .hd:
            return 0.4
        case .superhd:
            return 0.3
        }
    }
}


