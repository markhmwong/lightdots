//
//  MessageConfig+CoreDataProperties.swift
//  LightDots
//
//  Created by Mark Wong on 20/11/2022.
//
//

import Foundation
import CoreData


extension MessageConfig {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MessageConfig> {
        return NSFetchRequest<MessageConfig>(entityName: "MessageConfig")
    }

    @NSManaged public var scrollSpeed: Float
    @NSManaged public var feedback: Bool
    @NSManaged public var fontName: Int16
    @NSManaged public var textShadow: Bool
    @NSManaged public var textShadowType: Int16
    @NSManaged public var textShadowColour: String?
    @NSManaged public var fontSize: Int16
    @NSManaged public var fontBold: Bool
    @NSManaged public var fontItalic: Bool
    @NSManaged public var fontUnderline: Bool
    @NSManaged public var fontColour: String?
    @NSManaged public var backgroundColour: String?
    @NSManaged public var shimmerBackground: String?
    @NSManaged public var shimmerForeground: String?
    @NSManaged public var flashBackground: String?
    @NSManaged public var flashSpeed: Float
    @NSManaged public var selectedBackground: Int16
    @NSManaged public var resolution: Int16
    @NSManaged public var ledShape: Int16
    @NSManaged public var rainbowSpeed: Float
    @NSManaged public var toMessageCore: MessageCore?
    @NSManaged public var idle: Bool

}
