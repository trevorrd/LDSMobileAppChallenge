//
//  CallbackProtocol.swift
//  LDSMobileAppChallenge
//
//  Created by Trevor Duersch on 3/26/20.
//  Copyright © 2020 Twosome Solutions LLC. All rights reserved.
//

import Foundation

protocol CallbackProtocol {
    func dataLoadedSuccessfully(withData : Decodable?)
}
