//
//  MessageConfig+CoreDataClass.swift
//  LightDots
//
//  Created by Mark Wong on 20/11/2022.
//
//

import Foundation
import CoreData

@objc(MessageConfig)
public class MessageConfig: NSManagedObject {
    func setDefaults() {
        self.backgroundColour
    }
}
