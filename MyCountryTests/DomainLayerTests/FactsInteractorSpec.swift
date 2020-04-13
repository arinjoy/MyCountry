//
//  FactsInteractorSpec.swift
//  MyCountryTests
//
//  Created by Arinjoy Biswas on 10/4/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Quick
import Nimble
import RxSwift
@testable import MyCountry

final class FactsInteractorSpec: QuickSpec {
    
    var factsResult: FactsList!
    var error: APIError!

    override func spec() {
        
        var factsInteractor: FactsInteractor!

        describe("Facts Interactor Spec") {
            
            beforeEach {
                self.factsResult = nil
                self.error = nil
            }
            
            context("Facts finding") {
                
                it("should call Facts Finding service correctly") {
                    
                    let serviceSpy = FactsFindingServiceSpy()
                    factsInteractor = FactsInteractor(factsFindingService: serviceSpy)
                    
                    // when
                    factsInteractor.getFacts(completion: { _ in })
                    
                    // then
                    expect(serviceSpy.findFactsCalled).toEventually(beTrue())
                }
                
                context("Facts Finding service failed") {
                    
                    it("should return the error correctly for any general error") {
                        
                        let serviceMock = FactsFindingServiceMock(returningError: true, error: APIError.server)
                        factsInteractor = FactsInteractor(factsFindingService: serviceMock)
                        
                        // when
                        factsInteractor.getFacts(completion: { result in
                            switch result {
                            case .success(let result):
                                self.factsResult = result
                            case .failure(let error):
                                self.error = error
                            }
                        })
                        
                        // then
                        expect(self.factsResult).toEventually(beNil())
                        
                        expect(self.error).toNotEventually(beNil())
                        expect(self.error).toEventually(equal(APIError.server))
                    }
                }
                
                context("Facts Finding service succeeds") {
                    
                    it("should map the result correctly") {
                        
                        let serviceMock = FactsFindingServiceMock(returningError: false)
                        factsInteractor = FactsInteractor(factsFindingService: serviceMock)
                        
                        // when
                        factsInteractor.getFacts(completion: { result in
                            switch result {
                            case .success(let result):
                                self.factsResult = result
                            case .failure(let error):
                                self.error = error
                            }
                        })
                        
                        // then
                        expect(self.error).toEventually(beNil())
                        
                        expect(self.factsResult).toNotEventually(beNil(), timeout: 1.5)
                        let factsList = self.factsResult
                        expect(factsList?.subjectName).toEventually(equal("About New Zealand"))
                        expect(factsList?.facts.isEmpty).toEventually(beFalse())
                        
                        expect(factsList?.facts.first?.title).toEventually(equal("It's a magical land"))
                        expect(factsList?.facts.first?.description).toEventually(equal("We all live with wonders of natures everywhere.."))
                        expect(factsList?.facts.first?.webImageUrl).toEventually(equal("http://www.nz.com/free.png"))
                        
                        expect(factsList?.facts.last?.title).toEventually(equal("Kiwi"))
                        expect(factsList?.facts.last?.description).toEventually(equal("They are the most cute little birdies with great persona."))
                        expect(factsList?.facts.last?.webImageUrl).toEventually(equal("https://www.nz.com/kiwi.png"))
                    }
                }
                
                context("service gives data with redundant object information") {
                    
                    // Business logic checks on validation
                    
                    it("should return unknown error when facts subject name is empty") {
                        
                        let serviceMock = FactsFindingServiceMock(returningError: false,
                                                                  returningResponse: self.factsListWithEmptySubjectName())
                        factsInteractor = FactsInteractor(factsFindingService: serviceMock)
                        
                        // when
                        factsInteractor.getFacts(completion: { result in
                            switch result {
                            case .success(let result):
                                self.factsResult = result
                            case .failure(let error):
                                self.error = error
                            }
                        })
                        
                        // then
                        expect(self.factsResult).toEventually(beNil())
                        
                        expect(self.error).toEventually(equal(.unknown), timeout: 1.5)
                    }
                
                    it("should return unknown error when facts array is empty") {
                        
                        let serviceMock = FactsFindingServiceMock(returningError: false,
                                                                  returningResponse: self.factsListWithEmptyFacts())
                        factsInteractor = FactsInteractor(factsFindingService: serviceMock)
                        
                        // when
                        factsInteractor.getFacts(completion: { result in
                            switch result {
                            case .success(let result):
                                self.factsResult = result
                            case .failure(let error):
                                self.error = error
                            }
                        })
                        
                        // then
                        expect(self.factsResult).toEventually(beNil(), timeout: 1.5)
                    
                        expect(self.error).toNotEventually(beNil(), timeout: 1.5)
                        expect(self.error).toEventually(equal(.unknown), timeout: 1.5)
                    }
                }
            }
        }
    }

    // MARK: - Private Test Helpers
    
    private func factsListWithEmptySubjectName() -> FactsList {
        return FactsList(subjectName: "", facts: [Fact(title: "Hello", description: "world", webImageUrl: nil)])
    }
    
    private func factsListWithEmptyFacts() -> FactsList {
        return FactsList(subjectName: "Subject", facts: [])
    }
}
