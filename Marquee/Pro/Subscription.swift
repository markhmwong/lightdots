//
//  Subscription.swift
//  Marquee
//
//  Created by Mark Wong on 31/10/2022.
//

import RevenueCat
import UIKit

enum Subscription: Int, CaseIterable {
    case monthly
    case yearly
    case threeMonth
    
    var identifier: String {
        switch self {
        case .threeMonth:
            return "com.whizbang.subscription.threemonthly"
        case .yearly:
            return "com.whizbang.subscription.yearly"
        case .monthly:
            return "com.whizbang.subscription.monthly"
        }
    }
}
