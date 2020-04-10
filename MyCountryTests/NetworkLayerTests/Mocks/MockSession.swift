//
//  MockSession.swift
//  MyCountryTests
//
//  Created by Arinjoy Biswas on 10/4/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation
@testable import MyCountry

class MockSession: URLSession {
    
    var responseError: Error?
    var responseStatus: Int = 200
    var responseData: Data?
    var request: URLRequest?
    
    override func dataTask(with request: URLRequest,
                           completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {

        self.request = request
        let dataTask = MockSessionDataTask {
            let response = HTTPURLResponse(url: request.url!, statusCode: self.responseStatus, httpVersion: "1.0", headerFields: [:])
            completionHandler(self.responseData, response, self.responseError)
        }
        return dataTask
    }
}

private class MockSessionDataTask: URLSessionDataTask {

    var resumeBlock: () -> Void

    init(withResume resume: @escaping () -> Void) {
        resumeBlock = resume
    }

    override func resume() {
        resumeBlock()
    }

    override func cancel() {
        // Do nothing.
    }
}

