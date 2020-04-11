//
//  ImageLoadingService+TestDoubles.swift
//  MyCountryTests
//
//  Created by Arinjoy Biswas on 11/4/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation
import RxSwift
@testable import MyCountry

// MARK: - Spy

final class ImageLoadingServiceSpy: ImageLoadingClientType {

    // Spied calls
    var loadImageDataCalled: Bool = false
    
    // Spied values
    var webUrl: URL?
    
    func loadImageData(fromUrl webUrl: URL) -> Single<Data> {
        loadImageDataCalled = true
        self.webUrl = webUrl
        return Observable.empty().asSingle()
    }
}

// MARK: - Dummy

final class ImageLoadingServiceDummy: ImageLoadingClientType {
     func loadImageData(fromUrl webUrl: URL) -> Single<Data> {
        return Observable.empty().asSingle()
    }
}

// MARK: - Mock

final class ImageLoadingServiceMock: ImageLoadingClientType {

    /// Whether to return error outcome
    let returningError: Bool

    /// The pre-determined error to return if `returnError` is set true
    let error: Error?

    /// Response to return if no error for success case
    let returningResponse: Data?

    init(
        returningError: Bool = false,
        error: Error? = nil,
        returningResponse: Data? = nil
    ) {
        self.returningError = returningError
        self.error = error
        self.returningResponse = returningResponse
    }

    func loadImageData(fromUrl webUrl: URL) -> Single<Data> {
        if returningError {
            return Single.error(error ?? APIError.unknown)
        } else {
            return Single<Data>.just(returningResponse ?? Data())
        }
    }
}
