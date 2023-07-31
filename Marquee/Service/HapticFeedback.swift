//
//  Feedback.swift
//  Marquee
//
//  Created by Mark Wong on 4/10/2022.
//

import UIKit

class HapticFeedback: NSObject {
    
    public static var shared: HapticFeedback = HapticFeedback()
    
    private let generator = UINotificationFeedbackGenerator()
    
    func success() {
        generator.notificationOccurred(.success)
    }
}
