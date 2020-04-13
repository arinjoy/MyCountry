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
                    
                    expect(displaySpy.setTitleCalled).to(beTrue())
                }
                
                it("should not show loading indicator when facts are being loaded without refreshing needed") {
                    
                    interactorMock = FactsInteractorMock()
                    presenter = FactsListPresenter(interactor: interactorMock)
                    presenter.display = displaySpy
                    
                    // when
                    presenter.loadFacts(isRereshingNeeded: false)
                    
                    // then
                    expect(displaySpy.showLoadingIndicatorCalled).to(beFalse())
                    
                    expect(displaySpy.setTitleCalled).to(beFalse())
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
                        
                        expect(displaySpy.setTitleCalled).toEventually(beTrue())
                    }
                    
                    it("should update the list eventually") {
                        
                        // when
                        presenter.loadFacts(isRereshingNeeded: true)
                        
                        // then
                        expect(presenter.factsListDataSource.sections.isEmpty).toEventually(beFalse())
                        expect(presenter.factsListDataSource.sections.count).toEventually(equal(1))
                        expect(presenter.factsListDataSource.sections.first?.items.count).toEventually(equal(2))
                        
                        // Note: The presenter's transformer itself is individually tested
                        // for all nitty gritty trasnformer logic of data item into presentation items.

                        expect(displaySpy.updateListCalled).toEventually(beTrue())
                    }
                    
                    it("should update the facts title correctly") {
                        
                        // when
                        presenter.loadFacts(isRereshingNeeded: true)
                        
                        // then
                        expect(displaySpy.setTitleCalled).toEventually(beTrue())
                        expect(displaySpy.title).toEventually(equal("About New Zealand"))
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
                    
                    it("should not update the list eventually") {
                        
                        // when
                        presenter.loadFacts(isRereshingNeeded: true)
                        
                        // then
                        expect(displaySpy.updateListCalled).toNotEventually(beTrue())
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
