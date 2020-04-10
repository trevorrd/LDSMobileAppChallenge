//
//  IndividualPersistence.swift
//  LDSMobileAppChallenge
//
//  Created by Trevor Duersch on 4/10/20.
//  Copyright © 2020 Twosome Solutions LLC. All rights reserved.
//

import Foundation
import CoreData

extension Individual {
    
    // MARK: - Save Data
    
    func saveIndividualData() throws {
        let individualEntity = IndividualEntity(context: PersistenceService.context)
        if (self.id != nil) {
            individualEntity.id = Int32(id)
        } else {
            print("Id not set")
            throw PersistenceError.noIdSet
            return
        }
        individualEntity.firstName = self.firstName
        individualEntity.lastName = self.lastName
        individualEntity.birthdate = self.birthdate
        individualEntity.forceSensitive = self.forceSensitive
        individualEntity.affiliation = self.affiliation.rawValue
        individualEntity.profilePicture = self.profilePicture
        individualEntity.profileImage = self.profileImage
        
        PersistenceService.saveContext()
    }
    
    // MARK: - Load Data
    
    func loadIndividualData() -> [Individual] {
        var individuals : [Individual] = []
        let fetchRequest : NSFetchRequest<IndividualEntity> = IndividualEntity.fetchRequest()
        
        do {
            let individualEntities = try PersistenceService.context.fetch(fetchRequest)
            if (individualEntities.count > 0 ) {
                individuals = individualEntities
            }
            
            // Sort Individuals by ID
            individuals = individuals.sorted(by: { (individual1, individual2) in
                guard let ind1Id = individual1.individualData.id, let ind2Id = individual2.individualData.id else { return false }
                return ind1Id < ind2Id
            })
        } catch let error {
            print("Failed to load IndividualData! Details - \(error.localizedDescription)")
        }
        
        
        return individuals
    }
    
    // MARK: - Delete Data
    
    func deleteAllIndividualData() -> Bool {
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

}
