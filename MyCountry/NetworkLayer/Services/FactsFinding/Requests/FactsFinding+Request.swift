//
//  FactsFindingRequest.swift
//  MyCountry
//
//  Created by Arinjoy Biswas on 10/4/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation

final class FactsFindingRequest: BaseRequest {
    
    var urlRequest: URLRequest
    
    init(url: URL) {
       
        urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = HTTPRequestMethod.get.rawValue
        
        // Set 10 seconds timeout for the request,
        // otherwise defaults to 60 seconds which is too long.
        // This helps in custom error handling to test
        urlRequest.timeoutInterval = 10.0
        
        // Configure anyhting else for this request in future
    }
}
