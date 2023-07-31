//
//  LedFont.swift
//  Marquee
//
//  Created by Mark Wong on 13/11/2022.
//

import Foundation

enum FontList: Int, CaseIterable {
    case Arial = 0
    case Menlo
    case Helvetica
    case Avenir
    case CourierNew
    case Futura
    case Georgia
    
    var name: String {
        switch self {
        case .Arial:
            return "Arial"
        case .Avenir:
            return "Avenir"
        case .CourierNew:
            return "Courier New"
        case .Futura:
            return "Futura"
        case .Georgia:
            return "Georgia"
        case .Helvetica:
            return "Helvetica"
        case .Menlo:
            return "Menlo"
        }
    }
}
