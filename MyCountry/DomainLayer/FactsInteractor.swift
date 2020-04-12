//
//  FactsFindingInteractor.swift
//  MyCountry
//
//  Created by Arinjoy Biswas on 10/4/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation
import RxSwift

protocol FactsInteracting: class {
    
    /// Get some facts about a subject / something
    ///
    /// - Parameters:
    ///   - completion: The completion callback with success/failure
    func getFacts(completion: @escaping ((Result<FactsList, APIError>) -> Void))
    
    /// Downloads image data from an web url
    /// - Parameters:
    ///   - webUrl: webUrl to load the data from
    ///   - completion: The completion callback with data if loaded. `nil` is passsed to indicate not loaded due to some error
    func downloadImage(fromUrl webUrl: URL, completion: @escaping ((Data?) -> Void))
}

final class FactsInteractor: FactsInteracting {
    
    // RxSwift Disposebag
    private let disposeBag = DisposeBag()
    
    // MARK: - Private Propertires
    
    private let factsFindingService: FactsFindingClientType
    private let imageLoadingService: ImageLoadingClientType
    
    init(factsFindingService: FactsFindingClientType,
         imageLoadingService: ImageLoadingClientType) {
        self.factsFindingService = factsFindingService
        self.imageLoadingService = imageLoadingService
    }
    
    func getFacts(completion: @escaping ((Result<FactsList, APIError>) -> Void)) {
        
        factsFindingService.findFacts()
            .observeOn(MainScheduler.instance)
            
            // Add a slight delay to show asynchronous acitivity
            // [Used for testing only, But never in production app]
            .delay(1.0, scheduler: MainScheduler.instance)
            
            .subscribe(onSuccess: { factsList in
                
                // Apply some simple business use case validation here:
                // - Without the title of a subject what are the facts about?
                // - Without any facts in the array, what's the point of having dummy facts list?
                
                /**
                 Tech Notes:
                 From network/data layer objects, we can apply some level checks at domain layer as business case validation.
                 Technically the `NetworkLayer.XXX` object can be transformed into `DomainLayer.YYY` object
                 with additional data transformation,formatting or custom validation logic suited towards business need
                 Similarly `NetworkLayer.APIError` can also be converted into `DomainLayer.DomainError` for more granular
                 and cusotmised error handling and unit testing.
                 */
                
                if factsList.title.isEmpty || factsList.facts.isEmpty {
                    completion(.failure(APIError.unknown))
                } else {
                    completion(.success(factsList))
                }
                
            }, onError: { error in
                
                guard let apiError = error as? APIError else {
                    completion(.failure(APIError.unknown))
                    return
                }
                  
                // For all errors, just pass around the error to be handled by the receiver accordingly
                completion(.failure(apiError))
            })
            .disposed(by: disposeBag)
    }
    
    func downloadImage(fromUrl webUrl: URL, completion: @escaping ((Data?) -> Void)) {
        
        imageLoadingService.loadImageData(fromUrl: webUrl)
            .observeOn(MainScheduler.instance)
            
            // Add some delay to show asynchronous acitivity
            // [Used for testing only, But never in production app]
            //.delay(0.5, scheduler: MainScheduler.instance)
            
            .subscribe(onSuccess: { data in
                completion(data)
            }, onError: { _ in
                // Any error is indicated as `nil` outcome as there is no
                // custom error handling to manage here.
                completion(nil)
            })
            .disposed(by: disposeBag)
    }
}
