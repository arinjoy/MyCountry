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
    var imageResult: Data!
    var error: APIError!
    var disposeBag: DisposeBag!

    override func spec() {
        
        var factsInteractor: FactsInteractor!

        describe("Facts Interactor Spec") {
            
            beforeEach {
                self.disposeBag = DisposeBag()
            }
            
            afterEach {
                self.factsResult = nil
                self.imageResult = nil
                self.error = nil
                self.disposeBag = nil
            }
            
            context("Facts finding") {
                
                it("should call Facts Finding service correctly") {
                    
                    let serviceSpy = FactsFindingServiceSpy()
                    factsInteractor = FactsInteractor(factsFindingService: serviceSpy,
                                                      imageLoadingService: ImageLoadingServiceDummy())
                    
                    // when
                    factsInteractor.getFacts(completion: { _ in })
                    
                    // then
                    expect(serviceSpy.findFactsCalled).toEventually(beTrue())
                }
                
                context("Facts Finding service failed") {
                    
                    it("should return the error correctly for any general error") {
                        
                        let serviceMock = FactsFindingServiceMock(returningError: true, error: APIError.server)
                        factsInteractor = FactsInteractor(factsFindingService: serviceMock,
                                                          imageLoadingService: ImageLoadingServiceDummy())
                        
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
                        factsInteractor = FactsInteractor(factsFindingService: serviceMock,
                                                          imageLoadingService: ImageLoadingServiceDummy())
                        
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
                        
                        expect(self.factsResult).toNotEventually(beNil())
                        let factsList = self.factsResult
                        expect(factsList?.title).toEventually(equal("About New Zealand"))
                        expect(factsList?.facts.isEmpty).toEventually(beFalse())
                        
                        expect(factsList?.facts.first?.title).toEventually(equal("It's a magical land"))
                        expect(factsList?.facts.first?.description).toEventually(equal("We all live with wonders of natures everywhere.."))
                        expect(factsList?.facts.first?.imageUrl).toEventually(equal("http://www.nz.com/free.png"))
                        
                        expect(factsList?.facts.last?.title).toEventually(equal("Kiwi"))
                        expect(factsList?.facts.last?.description).toEventually(equal("They are the most cute little birdies with great persona."))
                        expect(factsList?.facts.last?.imageUrl).toEventually(equal("https://www.nz.com/kiwi.png"))
                    }
                }
                
                context("service gives data with redundant object information") {
                    
                    // Business logic checks on validation
                    
                    it("should return unknown error when facts subject name is empty") {
                        
                        let serviceMock = FactsFindingServiceMock(returningError: false,
                                                                  returningResponse: self.factsListWithEmptySubjectName())
                        factsInteractor = FactsInteractor(factsFindingService: serviceMock,
                                                          imageLoadingService: ImageLoadingServiceDummy())
                        
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
                        expect(self.error).toEventually(equal(.unknown))
                    }
                
                    it("should return unknown error when facts array is empty") {
                        
                        let serviceMock = FactsFindingServiceMock(returningError: false,
                                                                  returningResponse: self.factsListWithEmptyFacts())
                        factsInteractor = FactsInteractor(factsFindingService: serviceMock,
                                                          imageLoadingService: ImageLoadingServiceDummy())
                        
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
                        expect(self.error).toEventually(equal(.unknown))
                    }
                }
            }
            
            context("Image loading") {
                
                it("should call Image loading service correctly") {
                    
                    let serviceSpy = ImageLoadingServiceSpy()
                    factsInteractor = FactsInteractor(factsFindingService: FactsFindingServiceDummy(),
                                                      imageLoadingService: serviceSpy)
                    
                    // when
                    factsInteractor.downloadImage(fromUrl: self.sampleURL(), completion: { _ in })
                    
                    // then
                    expect(serviceSpy.loadImageDataCalled).toEventually(beTrue())
                }
                
                context("Image loading service succeeds") {
                
                    it("should return image data correctly") {
                        
                        let serviceMock = ImageLoadingServiceMock(returningError: false, returningResponse: self.sampleImageData())
                        factsInteractor = FactsInteractor(factsFindingService: FactsFindingServiceDummy(),
                                                          imageLoadingService: serviceMock)
                        
                        // when
                        factsInteractor.downloadImage(fromUrl: self.sampleURL(), completion: { imageResult in
                            self.imageResult = imageResult
                        })
                        
                        // then
                        expect(self.imageResult).toNotEventually(beNil())
                    }
                }
                
                context("Image loading service fails") {
                
                    it("should return a `nil` image") {
                        
                        let serviceMock = ImageLoadingServiceMock(returningError: true)
                        factsInteractor = FactsInteractor(factsFindingService: FactsFindingServiceDummy(),
                                                          imageLoadingService: serviceMock)
                        
                        // when
                        factsInteractor.downloadImage(fromUrl: self.sampleURL(), completion: { imageResult in
                            self.imageResult = imageResult
                        })
                        
                        // then
                        expect(self.imageResult).toEventually(beNil())
                    }
                }
            }
        }
    }

    // MARK: - Private Test Helpers
    
    private func factsListWithEmptySubjectName() -> FactsList {
        return FactsList(title: "", facts: [Fact(title: "Hello", description: "world", imageUrl: nil)])
    }
    
    private func factsListWithEmptyFacts() -> FactsList {
        return FactsList(title: "Subject", facts: [])
    }

    private func sampleURL() -> URL {
        return URL(string: "http://a.b.c/object.png")!
    }
    
    private func sampleImageData() -> Data {
        guard let data = UIImage(named: "placeholder")?.pngData() else {
            fatalError("Data cannot be constucted")
        }
        return data
    }
}
