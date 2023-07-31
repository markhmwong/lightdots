//
//  Whizbang.swift
//  Marquee
//
//  Created by Mark Wong on 24/10/2022.
//

import UIKit

extension Bundle {
    static func appName() -> String {
        guard let dictionary = Bundle.main.infoDictionary else {
            return ""
        }
        if let version : String = dictionary["CFBundleName"] as? String {
            return version
        } else {
            return ""
        }
    }
}

struct AppMetaData {
    static let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
    
    static let build = Bundle.main.infoDictionary!["CFBundleVersion"] as? String
    
    static let name = Bundle.appName()
}

final class Whizbang {
    static let shared: Whizbang = Whizbang()
    
    // Device parameters
    static let appName: String = AppMetaData.name
    static let appVersion: String = AppMetaData.version ?? "-1"
    static let appBuild: String = AppMetaData.build ?? "-1"
    static let deviceType = UIDevice().type
    static let systemVersion = UIDevice.current.systemVersion
    static let appStoreUrl: String = "https://apps.apple.com/app/id6443990050"
    
    static let emailBody: String = """
    </br>
    </br>\(appName): \(appVersion)\n
    </br>iOS: \(systemVersion)
    </br>Device: \(deviceType.rawValue)
    """
    
    static let emailToRecipient: String = "hello@whizbangapps.xyz"
    
    static let emailSubject: String = "\(appName) App Feedback"
    
    static let telemetryDeckAppId: String = "6A53999D-7385-4746-B597-A37D629A1870"

    static let madeInMelb: String = "Melbourne, Australia"
    
    static let twitter: String = "@_whizbangapps"
}
