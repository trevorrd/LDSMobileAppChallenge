//
//  Individual.swift
//  LDSMobileAppChallenge
//
//  Created by Trevor Duersch on 3/26/20.
//  Copyright © 2020 Twosome Solutions LLC. All rights reserved.
//

import Foundation

struct Individual : Decodable {
    let id : Int
    let firstName : String
    let lastName : String
    let birthdate : String
    let profilePicture : String
    let forceSensitive : Bool
    let affiliation : Affilition
    
    var profileImage : Data?
}
