//
//  JSONParser.swift
//  LDSMobileAppChallenge
//
//  Created by Trevor Duersch on 3/26/20.
//  Copyright © 2020 Twosome Solutions LLC. All rights reserved.
//

import Foundation

class JSONParser {
    static func parseJson<T>(_ type: T.Type, from data: Data) -> T? where T : Decodable {
        do {
            let rawData = try JSONDecoder().decode(type.self, from: data)
            return rawData
        } catch let parseJsonError {
            print("Error serializing JSON! \(parseJsonError)")
            return nil
        }
    }
    
    static func generateJsonData<T>(from data: T) -> Data? where T : Encodable {
        let jsonData = try! JSONEncoder().encode(data)
        
        return jsonData
    }
}
