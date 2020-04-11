//
//  FactsListPresenter.swift
//  MyCountry
//
//  Created by Arinjoy Biswas on 11/4/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation
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
    
    init(interactor: FactsInteracting) {
        self.interactor = interactor
    }
    
    /// The RxSwift disposing swift
    private let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - FactsListPresenting
    
    func viewDidBecomeReady() {
        // TODO: do any data preparation presetting of static text tasks etc.
    }
    
    func loadFacts(isRereshingNeeded: Bool) {
        
        // If refreshing is not needed, early exit with rendering based on preloaded data
        guard isRereshingNeeded else {
            if let factsList = factsListData {
                handleUpdatingDataSource(factsList)
            }
            return
        }
        
        self.display?.showLoadingIndicator()
        
        interactor.getFacts { [weak self] result in
            
            guard let self = self else { return }
            
            self.display?.hideLoadingIndicator()
            
            switch result {
            case .success(let factsList):
                
               self.handleUpdatingDataSource(factsList)
                
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
                
                self.display?.showError(title: errorTitle, message: errorMessage, dismissTitle: errorDismissTitle)
            }
        }
    }
    
    // MARK: - Private Helpers
    
    private func handleUpdatingDataSource(_ input: FactsList) {

        display?.setTitle(input.title)
        
        // Keep reference to the latest fetched facts data
        factsListData = input
        
        let dataSource = tranformer.transform(input: input.facts)
        display?.setFactsListDataSource(dataSource)
    }
}
