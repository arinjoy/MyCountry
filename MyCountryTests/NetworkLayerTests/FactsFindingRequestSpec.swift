//
//  FactsFindingRequestSpec.swift
//  MyCountryTests
//
//  Created by Arinjoy Biswas on 10/4/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Quick
import Nimble
@testable import MyCountry

final class FactsFindingRequestSpec: QuickSpec {

    override func spec() {
        
        describe("FactsFindingRequestSpec") {
            
            var request: FactsFindingRequest!
            
            context("when `FactsFindingRequest` is constructed") {
                
                beforeEach {
                    request = FactsFindingRequest(url: EndpointConfiguration.absoluteURL(for: .myCountryFacts))
                }
                
                it("should set the correct GET call type") {
                    expect(request.urlRequest.httpMethod) == HTTPRequestMethod.get.rawValue
                }
                
                it("should set the correct API path") {
                    expect(request.urlRequest.url) == EndpointConfiguration.absoluteURL(for: .myCountryFacts)
                }
                
                it("should set the correct time out interval") {
                    expect(request.urlRequest.timeoutInterval) == 10.0
                }
            }
        }
    }
}
