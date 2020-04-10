//
//  HTTPClientSpec.swift
//  MyCountryTests
//
//  Created by Arinjoy Biswas on 10/4/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Quick
import Nimble
import RxSwift
@testable import MyCountry

final class HTTPClientSpec: QuickSpec {

    override func spec() {
        
        describe("HTTP Client Spec") {
            
            var dataSource: ObservableDataSource!
            var mockSession: MockSession!
            
            beforeEach {
                mockSession = MockSession()
                dataSource = HTTPClient(withSession: mockSession)
            }
            
            describe("fetching single object") {
                
                context("when failure occurs") {
                 
                    it("handles network connectivity error") {
                        mockSession.responseError = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet)
                        testSingleFailureScenario(MockRequest(withURL: "www.abc.com"), forAPIError: .networkFailure)
                    }
                    
                    it("handles network connectivity error") {
                        mockSession.responseError = NSError(domain: NSURLErrorDomain, code: NSURLErrorTimedOut)
                        testSingleFailureScenario(MockRequest(withURL: "www.abc.com"), forAPIError: .timeout)
                    }
                    
                    it("handles 401 error") {
                        mockSession.responseStatus = 401
                        testSingleFailureScenario(MockRequest(withURL: "www.abc.com"), forAPIError: .unAuthorized)
                    }

                    it("handles 403 error") {
                        mockSession.responseStatus = 403
                        testSingleFailureScenario(MockRequest(withURL: "www.abc.com"), forAPIError: .forbidden)
                    }
                    
                    it("handles 404 error") {
                        mockSession.responseStatus = 404
                        testSingleFailureScenario(MockRequest(withURL: "www.abc.com"), forAPIError: .notFound)
                    }

                    it("handles 500 server error") {
                        mockSession.responseStatus = 500
                        testSingleFailureScenario(MockRequest(withURL: "www.abc.com"), forAPIError: .server)
                    }

                    it("handles 503 service unavailable error") {
                        mockSession.responseStatus = 503
                        testSingleFailureScenario(MockRequest(withURL: "www.abc.com"), forAPIError: .seviceUnavailable)
                    }
                    
                    it("handles when there is no data") {
                        mockSession.responseData = nil
                        mockSession.responseStatus = 200
                        testSingleFailureScenario(MockRequest(withURL: "www.abc.com"), forAPIError: .noDataFound)
                    }
                    
                    it("handles when there is data conversion issue") {
                        mockSession.responseData = Bundle(for: type(of: self)).jsonData(forResource: "testSample")
                        testSingleFailureScenario(MockRequest(withURL: "www.abc.com"), forAPIError: .dataConversionFailed)
                    }
                    
                    it("handles wwhen invalid JSON data is received") {
                        let json = "@hello@world{}[]"
                        mockSession.responseStatus = 200
                        mockSession.responseData = json.data(using: .utf8)
                        testSingleFailureScenario(MockRequest(withURL: "www.abc.com"), forAPIError: .dataConversionFailed)
                    }
                    
                    func testSingleFailureScenario(_ request: BaseRequest, forAPIError apiError: APIError, line: UInt = #line) {
                        _ = (dataSource.fetchSingleObject(with: request) as Single<X>)
                            .subscribe(onSuccess: { _ in
                                fail("Should not have called success", line: line)
                            },
                            onError: { error in
                                expect(error as? APIError, line: line).toNot(beNil())
                                expect(error as? APIError, line: line).to(equal(apiError))
                            })
                    }
                }
                
                context("when succeeds") {
                    
                    it("handles a 200..299 response with data") {
                        let json = """
                        {
                            "attribA": "Hello",
                            "attribB": 12345
                        }
                        """
                        mockSession.responseData = json.data(using: .utf8)
                        mockSession.responseStatus = 200
                        testSingleSuccessScenario(MockRequest(withURL: "www.abc.com"))
                    }
                    
                    func testSingleSuccessScenario(_ request: BaseRequest, line: UInt = #line) {
                        _ = (dataSource.fetchSingleObject(with: request) as Single<X>)
                            .subscribe(onSuccess: { x in
                                expect(x.attribA, line: line) == "Hello"
                                expect(x.attribB, line: line) == 12345
                            },
                            onError: { _ in
                                fail("Should not have called error", line: line)
                            })
                    }
                }
            }
        }
    }
}

private struct X: Decodable {
    let attribA: String
    let attribB: Int
}
