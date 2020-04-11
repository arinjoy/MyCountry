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
        // TODO: Do any preparation task such as loading indicator etc.
        
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
                
                // TODO: handle error alerts via display. Detect type and do custom handling
                break
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
