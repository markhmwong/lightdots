//
//  CoreDataStack.swift
//  Marquee
//
//  Created by Mark Wong on 3/10/2022.
//

import CoreData

class CoreDataStack: NSObject {
    
    static let shared = CoreDataStack()
    
    var moc: NSManagedObjectContext? = nil

    var backgroundContext: NSManagedObjectContext? = nil

    override init() {
        super.init()
        self.moc = self.persistentContainer.viewContext
        self.moc?.automaticallyMergesChangesFromParent = true
        self.backgroundContext = self.persistentContainer.newBackgroundContext()
    }
    
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentCloudKitContainer(name: "Marquee")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext(backgroundContext: NSManagedObjectContext? = nil) {
        
        if let context = backgroundContext {
            // background context is supplied
            guard context.hasChanges else { return }
            
            do {
                
                // save
                try context.save()
                guard let moc = moc else { return }
                
                moc.performAndWait {
                    do {
                        try moc.save()
                        #if DEBUG
                        print("saved")
                        #endif
                    } catch {
                        print("could not save on main context")
                    }
                }
            } catch let error as NSError {
                print("Error: \(error), \(error.userInfo)")
            }
        } else {
            // No background context is supplied through the method parameter
            guard let moc = moc else { return }
            moc.performAndWait {
                do {
                    #if DEBUG
                    print("saved")
                    #endif
                    try moc.save()
                } catch {
                    print("could not save on main context")
                }
            }
        }
    }
    
    func saveMessage(message: String) {
        guard let bc = self.backgroundContext else { return }
        
        // create message
        let m = MessageCore(context: bc)
        let config = MessageConfig(context: bc)
        config.backgroundColour = LedOptions.shared.loadSolidBackgroundColour()
        config.scrollSpeed = LedOptions.shared.loadScrollSpeed()
        config.feedback = LedOptions.shared.loadFeedback()
        config.fontName = Int16(LedOptions.shared.loadFont().rawValue)
        config.textShadow = LedOptions.shared.loadShadow()
        config.textShadowType = Int16(LedOptions.shared.loadShadowType().rawValue)
        config.textShadowColour = LedOptions.shared.loadShadowColour().hexStringFromColor()
        config.fontSize = Int16(LedOptions.shared.loadFontSize())
        config.fontBold = LedOptions.shared.loadBold()
        config.fontItalic = LedOptions.shared.loadItalic()
        config.fontUnderline = LedOptions.shared.loadUnderline()
        config.fontColour = LedOptions.shared.loadFontColour().hexStringFromColor()
        config.shimmerForeground = LedOptions.shared.loadShimmerForeground().hexStringFromColor()
        config.shimmerBackground = LedOptions.shared.loadShimmerBackground().hexStringFromColor()
        config.rainbowSpeed = LedOptions.shared.loadRainbowNoiseSpeed()
        config.flashBackground = LedOptions.shared.loadFlashBackground()
        config.flashSpeed = LedOptions.shared.loadFlashSpeed()
        config.selectedBackground = Int16(LedOptions.shared.loadSelectedBackground().rawValue)
        config.resolution = Int16(LedOptions.shared.loadResolution().rawValue)
        config.ledShape = Int16(LedOptions.shared.loadLedShape().rawValue)
        m.createMessageCore(message: message, config: config)
        saveContext(backgroundContext: bc)
    }
    
    func deleteMessage(obj: NSManagedObject) {

        if let c = self.moc {
            c.performAndWait {
                let request: NSFetchRequest<MessageCore> = MessageCore.fetchRequest()
                request.returnsObjectsAsFaults = false
                do {
                    c.delete(obj)
                    self.saveContext(backgroundContext: c)
                } catch let error as NSError {
                    print("WorkerObj entity could not be fetched or deleted \(error)")
                }
            }
        }
    }
    
    func fetchMessages(objIds: [NSManagedObjectID]) -> [MessageCore] {
        if let c = self.moc {
            let request: NSFetchRequest<MessageCore> = MessageCore.fetchRequest()
            request.returnsObjectsAsFaults = false
            request.predicate = NSPredicate(format: "self in %@", objIds)
            do {
                let fetchedResults = try c.fetch(request)
                return fetchedResults
            } catch let error as NSError {
                print("WorkerObj entity could not be fetched or deleted \(error)")
                return []
            }
        }
        return []
    }
}
