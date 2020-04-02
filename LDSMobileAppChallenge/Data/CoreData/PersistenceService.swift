//
//  PersistenceService.swift
//  LDSMobileAppChallenge
//
//  Created by Trevor Duersch on 3/31/20.
//  Copyright © 2020 Twosome Solutions LLC. All rights reserved.
//

import Foundation
import CoreData

class PersistenceService {
    
    // MARK: - Core Data stack
    
    static var context : NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "LDSMobileAppChallenge")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    static func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
