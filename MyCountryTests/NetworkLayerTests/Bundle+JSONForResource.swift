//
//  Bundle+JSONForResource.swift
//  MyCountryTests
//
//  Created by Arinjoy Biswas on 10/4/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation

extension Bundle {
    
    /// Loads a JSON file resource and returns its data
    func jsonData(forResource resource: String) -> Data {
        let resourceURL: URL = url(forResource: resource, withExtension: "json")!
        return try! Data(contentsOf: resourceURL)
    }
}
