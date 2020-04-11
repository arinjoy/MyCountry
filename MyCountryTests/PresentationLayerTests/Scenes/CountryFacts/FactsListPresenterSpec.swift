//
//  FactsListPresenterSpec.swift
//  MyCountryTests
//
//  Created by Arinjoy Biswas on 11/4/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Quick
import Nimble
@testable import MyCountry

final class FactsListPresenterSpec: QuickSpec {
    
    override func spec() {
        
        describe("Facts List Presenter Spec") {
            
            var presenter: FactsListPresenter!
            var displaySpy: FactsListDisplaySpy!
            
            it("should call correct display methods when view did become ready") {
                                
                presenter = FactsListPresenter(interactor: FactsInteractorDummy())
                displaySpy = FactsListDisplaySpy()
                presenter.display = displaySpy
                
                // when
                presenter.viewDidBecomeReady()
                
                // then
                // TODO: test any task taken inside viewDidBecomeReady
            }
            
            context("while communicating with interactor") {
                
                var interactorSpy: FactsInteractorSpy!
                var displayDummy: FactsListDisplayDummy!
                
                it("should talk to interactor when being asked to load facts with refreshing needed") {
                    
                    interactorSpy = FactsInteractorSpy()
                    presenter = FactsListPresenter(interactor: interactorSpy)
                    displayDummy = FactsListDisplayDummy()
                    presenter.display = displayDummy
                    
                    // when
                    presenter.loadFacts(isRereshingNeeded: true)
                    
                    // then
                    expect(interactorSpy.getFactsCalled).toEventually(beTrue())
                }
            }
            
            context("communication back with display on interactor behaviour") {
                
                var interactorMock: FactsInteractorMock!
                var displaySpy: FactsListDisplaySpy!
                
                beforeEach {
                    displaySpy = FactsListDisplaySpy()
                }
                
                it("should show loading indicator when facts are being loaded with refreshing needed") {
                    
                    interactorMock = FactsInteractorMock()
                    presenter = FactsListPresenter(interactor: interactorMock)
                    presenter.display = displaySpy
                    
                    // when
                    presenter.loadFacts(isRereshingNeeded: true)
                    
                    // then
                    expect(displaySpy.showLoadingIndicatorCalled).to(beTrue())
                }
                
                it("should not show loading indicator when facts are being loaded without refreshing needed") {
                    
                    interactorMock = FactsInteractorMock()
                    presenter = FactsListPresenter(interactor: interactorMock)
                    presenter.display = displaySpy
                    
                    // when
                    presenter.loadFacts(isRereshingNeeded: false)
                    
                    // then
                    expect(displaySpy.showLoadingIndicatorCalled).to(beFalse())
                }
                
                context("facts are loaded successfully") {
                    
                    beforeEach {
                        interactorMock = FactsInteractorMock(resultingError: false)
                        presenter = FactsListPresenter(interactor: interactorMock)
                        presenter.display = displaySpy
                    }
                    
                    it("should hide loading indicator eventually") {
                        
                        // when
                        presenter.loadFacts(isRereshingNeeded: true)
                        
                        // then
                        expect(displaySpy.hideLoadingIndicatorCalled).toEventually(beTrue())
                    }
                    
                    it("should set data source eventually") {
                        
                        // when
                        presenter.loadFacts(isRereshingNeeded: true)
                        
                        // then
                        expect(displaySpy.setFactsListDataSourceCalled).toEventually(beTrue())
                        
                        expect(displaySpy.factsListDataSource).toNotEventually(beNil())
                        expect(displaySpy.factsListDataSource?.sections.isEmpty).toEventually(beFalse())
                        
                    }
                }
                
                context("facts are loaded with error") {
                
                    beforeEach {
                        interactorMock = FactsInteractorMock(resultingError: true)
                        presenter = FactsListPresenter(interactor: interactorMock)
                        presenter.display = displaySpy
                    }
                    
                    it("should hide loading indicator eventually") {
                        
                        // when
                        presenter.loadFacts(isRereshingNeeded: true)
                        
                        // then
                        expect(displaySpy.hideLoadingIndicatorCalled).toEventually(beTrue())
                    }
                    
                    it("should not set any data source eventually") {
                        
                        // when
                        presenter.loadFacts(isRereshingNeeded: true)
                        
                        // then
                        expect(displaySpy.setFactsListDataSourceCalled).toNotEventually(beTrue())
                    }
                    
                    it("should show a generic error via display") {
                        
                        // when
                        presenter.loadFacts(isRereshingNeeded: true)
                        
                        // then
                        expect(displaySpy.showErrorCalled).toEventually(beTrue())
                        expect(displaySpy.errorTitle).toEventually(equal("Oops! Something wrong."))
                        expect(displaySpy.errorMessage).toEventually(equal("There is a generic error. Please try again later."))
                        expect(displaySpy.errorDismissTitle).toEventually(equal("OK"))
                    }
                    
                    context("when network error occurs") {
                        
                        beforeEach {
                            interactorMock = FactsInteractorMock(resultingError: true, error: APIError.networkFailure)
                            presenter = FactsListPresenter(interactor: interactorMock)
                            presenter.display = displaySpy
                        }
                        
                        it("should show a network failure error with correct message") {
                            // when
                            presenter.loadFacts(isRereshingNeeded: true)
                            
                            // then
                            expect(displaySpy.showErrorCalled).toEventually(beTrue())
                            expect(displaySpy.errorTitle).toEventually(equal("Oops! Something wrong."))
                            expect(displaySpy.errorMessage).toEventually(equal("Please check your network connection and try again."))
                            expect(displaySpy.errorDismissTitle).toEventually(equal("OK"))
                        }
                    }
                }
            }
        }
    }
}
