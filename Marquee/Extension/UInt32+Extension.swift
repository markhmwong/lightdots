//
//  UInt32.swift
//  Ledify
//
//  Created by Mark Wong on 8/3/2023.
//

import UIKit

extension UInt32 {
    
    static func colorToUInt32(_ color: UIColor) -> UInt32 {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        let redByte = UInt32(red * 255.0)
        let greenByte = UInt32(green * 255.0)
        let blueByte = UInt32(blue * 255.0)
        let alphaByte = UInt32(alpha * 255.0)

        let colorUInt32 = (alphaByte << 24) | (blueByte << 16) | (greenByte << 8) | redByte

        return colorUInt32
    }
    
}
