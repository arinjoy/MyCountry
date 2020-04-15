//
//  FactsListPresenter.swift
//  MyCountry
//
//  Created by Arinjoy Biswas on 11/4/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

final class FactsListPresenter: FactsListPresenting {
    
    /// The front-facing view that conforms to the `FactsListDisplay` protocol
    weak var display: FactsListDisplay?
        
    // MARK: - Private Properties
    
    private var factsListData: FactsList?
    
    /// The interactor for finding facts
    private let interactor: FactsInteracting!
    
    /// The data tranforming helper
    private let tranformer = FactsTransformer()
    
    private var imageLoadingQueue = OperationQueue()
    private var imageLoadingOperations: [IndexPath: ImageLoadOperation] = [:]
 
    /// The RxSwift disposing swift
    private let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    init(interactor: FactsInteracting) {
        self.interactor = interactor
    }
    
    // MARK: - FactsListPresenting
    
    var factsListDataSource: FactsListDataSource = FactsListDataSource()
    var factsImageStore: [IndexPath: UIImage?] = [:]
    
    func loadFacts(isRereshingNeeded: Bool) {
        
        self.display?.hideLoadingIndicator()
        
        // If refreshing is not needed, early exit with rendering based on preloaded data
        guard isRereshingNeeded else {
            if let factsList = factsListData {
                handleUpdatingListDataSource(factsList.facts)
            }
            return
        }
        
        self.display?.setTitle(StringKeys.MyCountryApp.viewLoadingTitle.localized())
        self.display?.showLoadingIndicator()
        
        // Clear any existing image loading operations and image store
        self.resetAllImageLoaders()
        
        // Clear out the list display with empty list for smotth re-rendering
        self.handleUpdatingListDataSource([])
        
        interactor.getFacts { [weak self] result in
            
            guard let self = self else { return }
            
            self.display?.hideLoadingIndicator()
            
            switch result {
            case .success(let factsList):
                
            // Update the display title with fact's subject name
            self.display?.setTitle(factsList.subjectName)
                
            // Keep a copy of the received data to load from it in
            // future if refreshinng is not needed
            self.factsListData = factsList
            self.handleUpdatingListDataSource(factsList.facts)
                
            case .failure(let error):
                
                let errorTitle: String = StringKeys.MyCountryApp.genericErrorTitle.localized()
                let errorDismissTitle: String = StringKeys.MyCountryApp.errorDismissActionTitle.localized()
                var errorMessage: String
                switch error {
                    // Show network connectivity error
                case .networkFailure, .timeout:
                    errorMessage = StringKeys.MyCountryApp.networkConnectionErrorMessage.localized()
                default:
                    // For all other errors, show this generic error
                    // This can be elaborated case by case basis of custom error handling
                    errorMessage = StringKeys.MyCountryApp.genericErrorMessage.localized()
                }
                
                self.display?.showError(title: errorTitle,
                                        message: errorMessage,
                                        dismissTitle: errorDismissTitle)
            }
        }
    }
    
    func addImageLoadOperation(atIndexPath indexPath: IndexPath, updateCellClosure: ((UIImage?) -> Void)?) {
        
        // If an image loader exists for this indexPath, do not add it again
        guard imageLoadingOperations[indexPath] == nil else { return }
        
        // Find the web Url of the rquired indexPath from the data source
        if let item = factsListDataSource.item(atIndexPath: indexPath),
            let webUrl = item.webImageUrl {
            
            // Create an image loader for the URL
            let imageLoader = ImageLoadOperation(withUrl: webUrl)
            
            // Attach completion closure when data arrives to update cell
            imageLoader.completionHandler = updateCellClosure
            
            imageLoadingQueue.addOperation(imageLoader)
            imageLoadingOperations[indexPath] = imageLoader
        }
    }
    
    func removeImageLoadOperation(atIndexPath indexPath: IndexPath) {

        // If there's a image loader for this index path and we don't
        // need it any more, then Cancel and Dispose
        if let imageLoader = imageLoadingOperations[indexPath] {
            imageLoader.cancel()
            imageLoadingOperations.removeValue(forKey: indexPath)
        }
    }
    
    // MARK: - Private Helpers
    
    private func handleUpdatingListDataSource(_ facts: [Fact]) {
        
        let sortedFacts = facts.sorted { $0.title ?? "" < $1.title ?? "" }
        
        let dataSource = tranformer.transform(input: sortedFacts)
        factsListDataSource = dataSource
        
        // Update the list UI on display as data source has been updated
        display?.updateList()
    }
    
    private func resetAllImageLoaders() {
        for (indexPath, _) in imageLoadingOperations {
            removeImageLoadOperation(atIndexPath: indexPath)
        }
        factsImageStore = [:]
    }
}
