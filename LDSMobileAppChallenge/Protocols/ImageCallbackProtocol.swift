//
//  ImageCallbackProtocol.swift
//  LDSMobileAppChallenge
//
//  Created by Trevor Duersch on 3/26/20.
//  Copyright © 2020 Twosome Solutions LLC. All rights reserved.
//

import Foundation

protocol ImageCallbackProtocol {
    func imageDataLoaded(from imageData : Data?, for id : Int)
}
