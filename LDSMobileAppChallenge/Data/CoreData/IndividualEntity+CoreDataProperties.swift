//
//  IndividualEntity+CoreDataProperties.swift
//  LDSMobileAppChallenge
//
//  Created by Trevor Duersch on 3/31/20.
//  Copyright © 2020 Twosome Solutions LLC. All rights reserved.
//
//

import Foundation
import CoreData


extension IndividualEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<IndividualEntity> {
        return NSFetchRequest<IndividualEntity>(entityName: "IndividualEntity")
    }

    @NSManaged public var affiliation: String?
    @NSManaged public var birthdate: String?
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var forceSensitive: Bool
    @NSManaged public var id: Int32
    @NSManaged public var profilePicture: String?
    @NSManaged public var profileImage: Data?

}
