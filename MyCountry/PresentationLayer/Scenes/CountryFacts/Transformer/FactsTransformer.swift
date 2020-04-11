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
    let title: NSAttributedString?
    let body: NSAttributedString?
    let webImageUrl: URL?
}

typealias FactsListDataSource = DataSource<DataSection<FactPresentationItem>>

struct FactsTransformer: DataTransforming {

    func transform(input: [Fact]) -> FactsListDataSource {
        
        let presentationItems: [FactPresentationItem] = input.map { item  in
            
            var titleText: NSAttributedString?
            if let title = item.title, !title.isEmpty {
                titleText = NSAttributedString(string: title, attributes: [.foregroundColor: Theme.primaryTextColor])
            }
            
            var bodyText: NSAttributedString?
            if let body = item.description, !body.isEmpty {
                bodyText = NSAttributedString(string: body, attributes: [.foregroundColor: Theme.primaryTextColor])
            }
            
            var webImageUrl: URL?
            if let urlString = item.imageUrl,
                let url = URL(string: urlString) {
                webImageUrl = url
            }
            return FactPresentationItem(title: titleText, body: bodyText, webImageUrl: webImageUrl)
        }
        
        // A single section combining all elements
        let dataSections = [DataSection<FactPresentationItem>(items: presentationItems)]
        return DataSource<DataSection<FactPresentationItem>>(sections: dataSections)
    }
}
