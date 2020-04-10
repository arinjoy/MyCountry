//
//  MockRequest.swift
//  MyCountryTests
//
//  Created by Arinjoy Biswas on 10/4/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation
@testable import MyCountry

class MockRequest: BaseRequest {
    private var url: URL
    
    var urlRequest: URLRequest {
        return URLRequest(url: url)
    }

    init(withURL url: String) {
        self.url = URL(string: url)!
    }
}
