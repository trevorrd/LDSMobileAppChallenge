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
    
    func saveIndividualData() {
        let individualEntity = IndividualEntity(context: PersistenceService.context)
        
        individualEntity.id = Int32(id)
        individualEntity.firstName = self.firstName
        individualEntity.lastName = self.lastName
        individualEntity.birthdate = self.birthdate
        individualEntity.forceSensitive = self.forceSensitive
        individualEntity.affiliation = self.affiliation.rawValue
        individualEntity.profilePicture = self.profilePicture
        individualEntity.profileImage = self.profileImage
        
        PersistenceService.saveContext()
    }
}
