//
//  ImageLoadingRequestSpec.swift
//  MyCountryTests
//
//  Created by Arinjoy Biswas on 13/4/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Quick
import Nimble
@testable import MyCountry

final class ImageLoadingRequestSpec: QuickSpec {

    override func spec() {
        
        describe("Image Loading Request Spec") {
            
            var request: ImageLoadingRequest!
            
            context("when `ImageLoadingRequest` is constructed") {
                
                beforeEach {
                    request = ImageLoadingRequest(url: URL(string: "http://abc.com.au/image.png")!)
                }
                
                it("should set the correct GET call type") {
                    expect(request.urlRequest.httpMethod) == HTTPRequestMethod.get.rawValue
                }
                
                it("should set the correct API path") {
                    expect(request.urlRequest.url?.absoluteString) == "http://abc.com.au/image.png"
                }
                
                it("should set the correct time out interval") {
                    expect(request.urlRequest.timeoutInterval) == 10.0
                }
            }
        }
    }
}
