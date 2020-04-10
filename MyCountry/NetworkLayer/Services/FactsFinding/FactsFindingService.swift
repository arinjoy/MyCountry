//
//  FactsFindingService.swift
//  MyCountry
//
//  Created by Arinjoy Biswas on 10/4/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation
import RxSwift

protocol FactsFindingClientType {
    
    /// Finds facts about something (i.e. facts about a country) by querying the network
    /// - Returns: A list of facts about the subject in terms of `Single<FactsList>`
    func findFacts() -> Single<FactsList>
}


/// A service client to retrieve facts about something
final class FactsFindingServiceClient: FactsFindingClientType {
    
    private let dataSource: ObservableDataSource
    
    init(dataSource: ObservableDataSource) {
        self.dataSource = dataSource
    }
    
    func findFacts() -> Single<FactsList> {
        
        let myCountryFactsRequest = FactsFindingRequest(url:
            EndpointConfiguration.absoluteURL(for: .myCountryFacts)
        )
        
        return dataSource.fetchSingleObject(with: myCountryFactsRequest)
    }
}

