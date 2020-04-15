//
//  FactsList+TestDoubles.swift
//  MyCountryTests
//
//  Created by Arinjoy Biswas on 11/4/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation
import UIKit
@testable import MyCountry

// MARK: - Dislay Dummy

final class FactsListDisplayDummy: FactsListDisplay {
    func setTitle(_ title: String) {}
    func updateList() {}
    func showLoadingIndicator() {}
    func hideLoadingIndicator() {}
    func showError(title: String, message: String, dismissTitle: String) {}
}

// MARK: - Dislay Spy

final class FactsListDisplaySpy: FactsListDisplay {
    
    // Spied calls
    var setTitleCalled: Bool = false
    var updateListCalled: Bool = false
    var showLoadingIndicatorCalled: Bool = false
    var hideLoadingIndicatorCalled: Bool = false
    var showErrorCalled: Bool = false
    
    // Spied values
    var title: String?
    var factsListDataSource: FactsListDataSource?
    var errorTitle: String?
    var errorMessage: String?
    var errorDismissTitle: String?
    
    func setTitle(_ title: String) {
        setTitleCalled = true
        self.title = title
    }
    
    func updateList() {
        updateListCalled = true
    }
    
    func showLoadingIndicator() {
        showLoadingIndicatorCalled = true
    }
    
    func hideLoadingIndicator() {
        hideLoadingIndicatorCalled = true
    }
    
    func showError(title: String, message: String, dismissTitle: String) {
        showErrorCalled = true
        errorTitle = title
        errorMessage = message
        errorDismissTitle = dismissTitle
    }
}

// MARK: - Presenter Dummy

final class FactsListPresenterDummy: FactsListPresenting {
    var factsListDataSource: FactsListDataSource = FactsListDataSource()
    var factsImageStore: [IndexPath: UIImage?] = [:]
    func viewDidBecomeReady() {}
    func loadFacts(isRereshingNeeded: Bool) {}
    func addImageLoadOperation(atIndexPath indexPath: IndexPath, updateCellClosure: ((UIImage?) -> Void)?) {}
    func removeImageLoadOperation(atIndexPath indexPath: IndexPath) {}
}

// MARK: - Presenter Spy

final class FactsListPresenterSpy: FactsListPresenting {
    
    // Spied calls
    var viewDidBecomeReadyCalled: Bool = false
    var loadFactsCalled: Bool = false
    var addImageLoadOperationCalled: Bool = false
    var removeImageLoadOperationCalled: Bool = false
    
    var factsListDataSource: FactsListDataSource = FactsListDataSource()
    var factsImageStore: [IndexPath: UIImage?] = [:]
    
    func viewDidBecomeReady() {
        viewDidBecomeReadyCalled = true
    }
    
    func loadFacts(isRereshingNeeded: Bool) {
        loadFactsCalled = true
    }
    
    func addImageLoadOperation(atIndexPath indexPath: IndexPath, updateCellClosure: ((UIImage?) -> Void)?) {
        addImageLoadOperationCalled = true
    }
    
    func removeImageLoadOperation(atIndexPath indexPath: IndexPath) {
        removeImageLoadOperationCalled = true
    }
}

// MARK: - Interactor Dummy

final class FactsInteractorDummy: FactsInteracting {
    func getFacts(completion: @escaping ((Result<FactsList, APIError>) -> Void)) {}
    func downloadImage(fromUrl webUrl: URL, completion: @escaping ((Data?) -> Void)) {}
}

// MARK: - Interactor Spy

final class FactsInteractorSpy: FactsInteracting {
    
    // Spied calls
    var getFactsCalled: Bool = false
    var downloadImageCalled: Bool = false
    
    func getFacts(completion: @escaping ((Result<FactsList, APIError>) -> Void)) {
        getFactsCalled = true
    }
    
    func downloadImage(fromUrl webUrl: URL, completion: @escaping ((Data?) -> Void)) {
        downloadImageCalled = true
    }
}

// MARK: - Interactor Mock

final class FactsInteractorMock: FactsInteracting {
    
        var resultingError: Bool
        var error: APIError
        var resultingFacts: FactsList
        var resultingImageData: Data
    
        init(
            resultingError: Bool = false,
            error: APIError = APIError.unknown,
            resultingFacts: FactsList = FactsInteractorMock.sampleFactsList(),
            resultingImageData: Data = Data()
        ) {
            self.resultingError = resultingError
            self.error = error
            self.resultingFacts = resultingFacts
            self.resultingImageData = resultingImageData
        }
    
    func getFacts(completion: @escaping ((Result<FactsList, APIError>) -> Void)) {
        if resultingError {
            completion(Result.failure(self.error))
        } else {
            completion(Result.success(self.resultingFacts))
        }
    }
    
    func downloadImage(fromUrl webUrl: URL, completion: @escaping ((Data?) -> Void)) {
        if resultingError {
            completion(nil)
        }
        completion(resultingImageData)
    }
    
    // MARK: - Private Test Helpers

    private static func sampleFactsList() -> FactsList {
        return FactsList(
            subjectName: "About New Zealand",
            facts: [Fact(title: "It's a magical land",
                         description: "We all live with wonders of natures everywhere..",
                         webImageUrl: "http://www.nz.com/free.png"),
                    Fact(title: "Kiwi",
                         description: "They are the most cute little birdies with great persona.",
                         webImageUrl: "https://www.nz.com/kiwi.png"), ])
    }
}
