//
//  BackgroundProperties.swift
//  Marquee
//
//  Created by Mark Wong on 10/10/2022.
//

import UIKit

// horizontal scrolling
enum BackgroundProperties: Int, CaseIterable {
    case solid
    //case gradient
    // Quick fade in/out
    
    // random noise or just arc4random on each pixel with random fades
    case flash
    
    case noise
    case rainbowNoise
    case shimmer
    
    // like tik tok maybe a font
//        case shift // like tik tok
    // responds to sound from the microphone
//        case frequency
    
    
    var name: String {
        switch self {
//        case .gradient:
//            return "gradient"
        case .shimmer:
            return "shimmer"
        case .flash:
            return "flash"
        case .solid:
            return "solid"
        case .rainbowNoise:
            return "rainbow noise"
        case .noise:
            return "noise"
//            case .frequency:
//                return "frequency"
        }
    }
}
