//
//  AppStoreReviewManager.swift
//  Warmup HIIT Timer
//
//  Created by Mark Wong on 4/6/20.
//  Copyright © 2020 Mark Wong. All rights reserved.
//

import StoreKit

extension UIApplication {
    var currentScene: UIWindowScene? {
        connectedScenes.first { $0.activationState == .foregroundActive } as? UIWindowScene
    }
}

enum AppStoreReviewManager {
    static let minimumReviewWorthyActionCount = 4
    
    static func requestReviewIfAppropriate() {
        let defaults = UserDefaults.standard
        let bundle = Bundle.main
        var actionCount = defaults.integer(forKey: .reviewWorthyActionCount)
        actionCount += 1
        defaults.set(actionCount, forKey: .reviewWorthyActionCount)

        guard actionCount >= minimumReviewWorthyActionCount else {
            return
        }

        let bundleVersionKey = kCFBundleVersionKey as String
        let currentVersion = bundle.object(forInfoDictionaryKey: bundleVersionKey) as? String
        let lastVersion = defaults.string(forKey: .lastReviewRequestAppVersion)
        

        guard lastVersion == nil || lastVersion != currentVersion else {
            return
        }
        
		if let scene = UIApplication.shared.currentScene {
			SKStoreReviewController.requestReview(in: scene)
		}

        defaults.set(0, forKey: .reviewWorthyActionCount)
        defaults.set(currentVersion, forKey: .lastReviewRequestAppVersion)
    }
}

extension UserDefaults {
    enum Key: String {
        case reviewWorthyActionCount
        case lastReviewRequestAppVersion
    }
    
    func integer(forKey key: Key) -> Int {
        return integer(forKey: key.rawValue)
    }
    
    func string(forKey key: Key) -> String? {
        return string(forKey: key.rawValue)
    }
    
    func set(_ integer: Int, forKey key: Key) {
        set(integer, forKey: key.rawValue)
    }
    
    func set(_ object: Any?, forKey key: Key) {
        set(object, forKey: key.rawValue)
    }
}
