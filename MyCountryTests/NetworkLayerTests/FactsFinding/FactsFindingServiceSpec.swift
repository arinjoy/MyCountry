//
//  FactsFindingServiceSpec.swift
//  MyCountryTests
//
//  Created by Arinjoy Biswas on 10/4/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Quick
import Nimble
import RxSwift
@testable import MyCountry

final class FactsFindingServiceSpec: QuickSpec {
    
    override func spec() {
        
        describe("Facts Finding Service Spec") {
            
            var disposeBag: DisposeBag!
            
            beforeEach {
                disposeBag = DisposeBag()
            }
            
            afterEach {
                disposeBag = nil
            }
            
            it("should call a GET request on the api client") {
                
                let dataSourceSpy = ObservableDataSourceSpy()
                
                let service = FactsFindingServiceClient(dataSource: dataSourceSpy)
                
                // when
                service.findFacts()
                    .subscribe()
                    .disposed(by: disposeBag)
                
                // then
                expect(dataSourceSpy.fetchSingleObjectCalled).to(beTrue())
                
                expect(dataSourceSpy.request?.urlRequest.httpMethod)
                    .to(equal(HTTPRequestMethod.get.rawValue))
                
                expect(dataSourceSpy.request?.urlRequest.url)
                    .to(equal(EndpointConfiguration.absoluteURL(for: .myCountryFacts)))
                
            }
            
            it("should pass the response from the api client unchanged when succeeds") {

                let dataSourceMock = ObservableDataSourceMock(
                    response: self.sampleFactsList(),
                    returningError: false  // No error returned, means response is returned with success
                )
                var expectedError: Error?
                var receivedResponse: FactsList?

                let service = FactsFindingServiceClient(dataSource: dataSourceMock)

                // when
                service.findFacts()
                    .subscribe(onSuccess: { response in
                        receivedResponse = response
                    }, onError: { error in
                        expectedError = error
                    }).disposed(by: disposeBag)

                // then
                expect(expectedError).to(beNil())
                
                expect(receivedResponse).toNot(beNil())
                expect(receivedResponse?.subjectName).to(equal("About Australia"))
                expect(receivedResponse?.facts.count).to(equal(2))
                
                expect(receivedResponse?.facts.first?.title).to(equal("It's free"))
                expect(receivedResponse?.facts.first?.description).to(equal("We all live peacefully"))
                expect(receivedResponse?.facts.first?.webImageUrl).to(equal("http://www.australia.com/free.png"))
                
                expect(receivedResponse?.facts.last?.title).to(equal("Kangaroo"))
                expect(receivedResponse?.facts.last?.description).to(equal("They are the best jumpers but also deadly kickboxers"))
                expect(receivedResponse?.facts.last?.webImageUrl).to(equal("https://www.australia.com/kangaroo.png"))
            }

            it("should pass error from the api client when fails") {

                let dataSourceMock = ObservableDataSourceMock(
                    response: self.sampleFactsList(),
                    returningError: true,  // Error returned, means no response will be returned due to failure
                    error: APIError.server
                )
                var expectedError: Error?
                var receivedResponse: FactsList?

                let service = FactsFindingServiceClient(dataSource: dataSourceMock)

                // when
                service.findFacts()
                    .subscribe(onSuccess: { response in
                        receivedResponse = response
                    }, onError: { error in
                        expectedError = error
                    }).disposed(by: disposeBag)

                // then
                expect(receivedResponse).to(beNil())
                expect(expectedError).toNot(beNil())
                expect(expectedError as? APIError).to(equal(APIError.server))
            }
        }
    }
    
    // MARK: - Private Test Helpers
    
    private func sampleFactsList() -> FactsList {
        return FactsList(
            subjectName: "About Australia",
            facts: [Fact(title: "It's free",
                         description: "We all live peacefully",
                         webImageUrl: "http://www.australia.com/free.png"),
                    Fact(title: "Kangaroo",
                         description: "They are the best jumpers but also deadly kickboxers",
                         webImageUrl: "https://www.australia.com/kangaroo.png"), ])
    }
}
