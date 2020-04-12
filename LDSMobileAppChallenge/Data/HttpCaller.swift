//
//  HttpCaller.swift
//  LDSMobileAppChallenge
//
//  Created by Trevor Duersch on 3/26/20.
//  Copyright © 2020 Twosome Solutions LLC. All rights reserved.
//

import Foundation

enum HTTPMethod : String {
    case GET
    case PUT
    case POST
    case DELETE
}

class HttpCaller {
    var callBackProtocol : CallbackProtocol?
    var imageCallbackProtocol : ImageCallbackProtocol?
    var url : URL
    var urlRequest : NSMutableURLRequest
    let session = URLSession.shared
    
    // MARK: - Constructor(s)
    
    init(urlString: String, method : HTTPMethod) {
        self.url = URL(string: urlString)! // URLs are an exception to force unwrapping
        self.urlRequest = NSMutableURLRequest(url: self.url)
        self.urlRequest.httpMethod = method.rawValue
    }
    
    // MARK: - Methods
    
    // Used generic so I can get different types of data including but not limited to: Nominators, Rewards, Users, Nominations, etc...
    func getRemoteResponse<T : Decodable>(ofType: T.Type) {
        session.dataTask(with: self.urlRequest as URLRequest, completionHandler: { (data, response, error) in
            guard let rawData = data, let _:URLResponse = response, error == nil else { return }
            
            if (!self.isValidResponseHeaders(response: response)) {
                print("Error with Response Headers!")
                return
            }
            
            let jsonDataResponse = JSONParser.parseJson(ofType, from: rawData)
            self.doCallback(with: jsonDataResponse)
            
        }).resume()
    }
    
    func sendRemoteRequest(with jsonData: Data) {
        self.setHeaders()
        let task = session.uploadTask(with: self.urlRequest as URLRequest, from: jsonData) { (data, response, error) in
            guard let rawData = data, let _:URLResponse = response, error == nil else { return }
            
            if (!self.isValidResponseHeaders(response: response)) {
                print("Error with Response Headers!")
                return
            }
            
            let jsonDataResponse = JSONParser.parseJson(Individual.self, from: rawData)
            
            self.doCallback(with: jsonDataResponse)
        }
        task.resume()
    }
    
    func getImageResponse(for id : Int) {
        session.dataTask(with: self.urlRequest as URLRequest, completionHandler: { (data, response, error) in
            guard let rawData = data, let _:URLResponse = response, error == nil else { return }
            
            self.doImageCallback(with: rawData, for: id)
            
        }).resume()
    }
    
    // MARK: - Helper Methods
    
    private func setHeaders() {
        urlRequest.setValue(TEXT_PLAIN, forHTTPHeaderField: CONTENT_TYPE)
        urlRequest.setValue("Powered by Swift", forHTTPHeaderField: "X-Powered-By")
    }
    
    func isValidResponseHeaders(response: URLResponse?) -> Bool {
        guard let responseStatus = response as? HTTPURLResponse, (200...299).contains(responseStatus.statusCode) else {
            print("Server error! Did not get HTTP 200 response back!")
            return false
        }
        
        guard let mime = response?.mimeType, mime == TEXT_PLAIN else {
            print("Wrong MIME type! Expecting \(TEXT_PLAIN).")
            return false
        }
        
        return true
    }
    
    func doCallback(with jsonResponse : Decodable?) {
        guard let callBackObject = self.callBackProtocol else { return }
        guard let jsonResponse = jsonResponse else { return }
        callBackObject.dataLoadedSuccessfully(withData: jsonResponse)
    }
    
    func doImageCallback(with imageData: Data?, for id : Int) {
        guard let imageData = imageData else { return }
        guard let imageCallBackObject = self.imageCallbackProtocol else { return }
        imageCallBackObject.imageDataLoaded(from: imageData, for: id)
    }
}
