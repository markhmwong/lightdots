//
//  SubscriptionService.swift
//  Marquee
//
//  Created by Mark Wong on 3/10/2022.
//

import KeychainSwift
import UIKit
import RevenueCat

class SubscriptionService: NSObject {
    
    static var shared: SubscriptionService = SubscriptionService()
    
    private let keychain = KeychainSwift()
    
    private var isPro: Bool = false
    
    override init() {
        super.init()
        self.keychain.synchronizable = true
        self.isPro = (keychain.get("isPro") != nil)
    }
    
    func checkProStatus() {
        Purchases.shared.getCustomerInfo { custInfo, error in
            // custInfo
            if let entitlements = custInfo?.entitlements["pro"] {
                self.updateProState(entitlements.isActive)

            }
        }
    }
    
    func updateProState(_ state: Bool) {
        keychain.set(state, forKey: "isPro")
    }
    
    func proStatus() -> Bool {
        #if DEBUG
        return true
        #else
        return keychain.getBool("isPro") ?? false
        #endif
    }
    
    func lockImage(_ imageName: String? = nil) -> UIImage? {
        if self.proStatus() {
            return UIImage(systemName: "\(imageName ?? "")")
        } else {
            return UIImage(systemName: "lock.fill")
        }
    }
}
