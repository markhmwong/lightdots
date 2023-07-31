//
//  WarningBox.swift
//  Celebrate
//
//  Created by Mark Wong on 1/6/2022.
//

import UIKit

class WarningBox: NSObject {
    static func showProPayWall(_ vc : UIViewController, message: String) {
        showCustomAlertBox(title: "Pro Feature Only", message: message, vc: vc)
    }
    
    static func showCustomAlertBoxWithNoDefaults(title: String, message: String, vc: UIViewController, additionalActions: [UIAlertAction]? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let alerts = additionalActions {
            for a in alerts {
                alert.addAction(a)
            }
        }
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func showCustomAlertBox(title: String, message: String, vc: UIViewController, additionalActions: [UIAlertAction]? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                ()
            case .cancel, .destructive:
                () // do nothing
            @unknown default:
                () // do nothing
            }
        }))
        
        if let alerts = additionalActions {
            for a in alerts {
                alert.addAction(a)
            }
        }
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func showDeleteBox(title: String, message: String, vc: UIViewController, completionHandler: @escaping () -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { action in
            completionHandler()
        }))
        
        alert.addAction(UIAlertAction(title: "Take me back", style: .default, handler: { action in  }))
        
        vc.present(alert, animated: true, completion: nil)
    }
}
