//
//  Telemetry+Extension.swift
//  Marquee
//
//  Created by Mark Wong on 24/10/2022.
//

import Foundation
import TelemetryClient

extension TelemetryManager {
    static var appId: String = "A616135C-3931-4520-A801-A2FF04825630"
    enum Signal: String {
        case subscriptionDidShow
        case subscriptionDidPurchase
        case bannerOptionsDidShow
        
        //options
        case fontSettingsDidShow
        case fontColourDidShow
        case backgroundDidShow
        case borderLedDidShow
        case shadowDidShow
        case feedbackDidEnable
        case feedbackDidDisable
        case sdDidEnable
        case superSDDidEnable
        case hdDidEnable
        
        case appDidBecomeActive
        case appDidBegin
        case appDidBecomeInactive
        case appDidEnterForeground
        case appDidEnterBackground
        case appDidDisconnect
        case appWillResignActive
        
    }
}

