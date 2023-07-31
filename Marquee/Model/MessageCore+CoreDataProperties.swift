//
//  MessageCore+CoreDataProperties.swift
//  LightDots
//
//  Created by Mark Wong on 20/11/2022.
//
//

import Foundation
import CoreData


extension MessageCore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MessageCore> {
        return NSFetchRequest<MessageCore>(entityName: "MessageCore")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var message: String?
    @NSManaged public var toMessageConfig: MessageConfig?

}
