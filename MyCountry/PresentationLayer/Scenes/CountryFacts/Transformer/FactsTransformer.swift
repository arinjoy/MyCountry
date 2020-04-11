//
//  FactsTransformer.swift
//  MyCountry
//
//  Created by Arinjoy Biswas on 11/4/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation

/// A struct to hold presented/formatted version of a fact to bind to an UI element / cell
struct FactPresentationItem {
    let title: String?
    let body: String?
}

typealias FactsListDataSource = DataSource<DataSection<FactPresentationItem>>

struct FactsTransformer: DataTransforming {

    func transform(input: [Fact]) -> FactsListDataSource {
        
        let presentationItems: [FactPresentationItem] = input.map { item  in
            
            // TODO: do any additional view related formatting or atrributed text conversion etc. here
            let item = FactPresentationItem(title: item.title, body: item.description)
            return item
        }
        
        // A single section comibining all elements
        let dataSections = [DataSection<FactPresentationItem>(items: presentationItems)]
        return DataSource<DataSection<FactPresentationItem>>(sections: dataSections)
    }
}

