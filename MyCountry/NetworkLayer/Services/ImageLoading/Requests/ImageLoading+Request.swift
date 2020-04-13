//
//  ImageLoading+Request.swift
//  MyCountry
//
//  Created by Arinjoy Biswas on 13/4/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation

final class ImageLoadingRequest: BaseRequest {
    
    var urlRequest: URLRequest
    
    init(url: URL) {
       
        urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = HTTPRequestMethod.get.rawValue
        
        // Set 10 seconds timeout for the request,
        // otherwise defaults to 60 seconds which is too long.
        // This helps to observe image is loaded within 10 sconds or not
        urlRequest.timeoutInterval = 10.0
        
        // Configure anyhting else for this request in future
    }
}
