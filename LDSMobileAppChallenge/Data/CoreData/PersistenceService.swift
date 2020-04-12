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

extension PersistenceService {
    
    // MARK: - Load Data
    
    static func loadIndividualData() -> [Individual] {
        var individuals : [Individual] = []
        let fetchRequest : NSFetchRequest<IndividualEntity> = IndividualEntity.fetchRequest()
        
        do {
            let individualEntities = try PersistenceService.context.fetch(fetchRequest)
            if (individualEntities.count > 0 ) {
                //individuals = individualEntities
                for entity in individualEntities {
                    guard let individual = PersistenceService.individualConversion(from: entity) else { return [] }
                    individuals.append(individual)
                }
            }
            
            // Sort Individuals by ID
            individuals = individuals.sorted(by: { (individual1, individual2) in
                let ind1Id = individual1.id, ind2Id = individual2.id
                return ind1Id < ind2Id
            })
        } catch let error {
            print("Failed to load IndividualData! Details - \(error.localizedDescription)")
        }
        
        return individuals
    }
    
    // MARK: - Delete Data
    
    static func deleteAllIndividualData() -> Bool {
        let fetchRequest : NSFetchRequest<IndividualEntity> = IndividualEntity.fetchRequest()
        
        do {
            let individualEntities = try PersistenceService.context.fetch(fetchRequest)
            for individualEntity in individualEntities {
                PersistenceService.context.delete(individualEntity)
            }
            PersistenceService.saveContext()
        } catch let error {
            print("Failed to delete InDividualData! Details - \(error.localizedDescription)")
            return false
        }
        
        return true
    }
    
    // MARK: - Helper methods
    
    static func individualConversion(from entity: IndividualEntity) -> Individual? {
        guard let affiliation = entity.affiliation, let firstName = entity.firstName, let lastName = entity.lastName, let birthdate = entity.birthdate, let profilePicture = entity.profilePicture else { return nil }
        
        let individual = Individual(id: Int(entity.id), firstName: firstName, lastName: lastName, birthdate: birthdate, profilePicture: profilePicture, forceSensitive: entity.forceSensitive, affiliation: Affiliation(rawValue: affiliation)!)
        
        // Get the image data or else just return what we have
        guard let profileImage = entity.profileImage else { return individual }
        individual.profileImage = profileImage
        
        return individual
        
    }
}
