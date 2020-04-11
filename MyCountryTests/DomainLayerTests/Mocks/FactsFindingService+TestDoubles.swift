//
//  FactsFindingService+TestDoubles.swift
//  MyCountryTests
//
//  Created by Arinjoy Biswas on 10/4/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation
import RxSwift
@testable import MyCountry

// MARK: - Spy

final class FactsFindingServiceSpy: FactsFindingClientType {
    
    // Spied calls
    var findFactsCalled: Bool = false
    
    func findFacts() -> Single<FactsList> {
        findFactsCalled = true
        return Observable.empty().asSingle()
    }
}

// MARK: - Dummy

final class FactsFindingServiceDummy: FactsFindingClientType {
    func findFacts() -> Single<FactsList> {
        return Observable.empty().asSingle()
    }
}

// MARK: - Mock

final class FactsFindingServiceMock: FactsFindingClientType {
    
    /// Whether to return error outcome
    let returningError: Bool

    /// The pre-determined error to return if `returnError` is set true
    let error: Error?

    /// Response to return if no error for success case
    let returningResponse: FactsList?

    init(
        returningError: Bool = false,
        error: Error? = nil,
        returningResponse: FactsList? = nil
    ) {
        self.returningError = returningError
        self.error = error
        self.returningResponse = returningResponse
    }
    
    func findFacts() -> Single<FactsList> {
        if returningError {
            return Single.error(error ?? APIError.unknown)
        } else {
            return Single<FactsList>.just(returningResponse ?? sampleFactsList())
        }
    }
    
    // MARK: - Private Test Helpers

    private func sampleFactsList() -> FactsList {
        return FactsList(
            title: "About New Zealand",
            facts: [Fact(title: "It's a magical land",
                         description: "We all live with wonders of natures everywhere..",
                         imageUrl: "http://www.nz.com/free.png"),
                    Fact(title: "Kiwi",
                         description: "They are the most cute little birdies with great persona.",
                         imageUrl: "https://www.nz.com/kiwi.png"), ])
    }
}
