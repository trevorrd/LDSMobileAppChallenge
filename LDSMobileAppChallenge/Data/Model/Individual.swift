//
//  Individual.swift
//  LDSMobileAppChallenge
//
//  Created by Trevor Duersch on 3/26/20.
//  Copyright © 2020 Twosome Solutions LLC. All rights reserved.
//

import Foundation

class Individual : Decodable {
    var id : Int
    var firstName : String
    var lastName : String
    var birthdate : String
    var profilePicture : String
    var forceSensitive : Bool
    var affiliation : Affiliation
    
    var profileImage : Data?
    
    init(id: Int, firstName : String, lastName : String, birthdate : String, profilePicture : String, forceSensitive : Bool, affiliation : Affiliation) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.birthdate = birthdate
        self.profilePicture = profilePicture
        self.forceSensitive = forceSensitive
        self.affiliation = affiliation
    }
    
}
