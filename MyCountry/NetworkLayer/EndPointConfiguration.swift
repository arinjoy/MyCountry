//
//  EndPointConfiguration.swift
//  MyCountry
//
//  Created by Arinjoy Biswas on 10/4/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation

enum Endpoint: String {
    
    /// Some facts about a country.
    case myCountryFacts = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
}

struct EndpointConfiguration {
    
    static func absoluteURL(for endpoint: Endpoint) -> URL {
        
        guard let url = URL(string: endpoint.rawValue) else {
            fatalError("\(endpoint.rawValue) must be incorrect")
        }
        
        return url
    }
}

