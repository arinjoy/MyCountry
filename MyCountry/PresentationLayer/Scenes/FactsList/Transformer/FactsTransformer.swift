//
//  FactsTransformer.swift
//  MyCountry
//
//  Created by Arinjoy Biswas on 11/4/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation
import UIKit

/// A struct to hold presented/formatted version of a fact to bind to an UI element / cell
struct FactPresentationItem {
    
    /// The formatted title string of the fact
    let title: NSAttributedString?
    
    /// The formatted body string of the fact
    let body: NSAttributedString?
    
    /// The web Url of the image/photo of the fact
    let webImageUrl: URL?
    
    struct Accessibility {
        let titleAccessibility: AccessibilityConfiguration?
        let bodyAccessibility: AccessibilityConfiguration?
        let imageAccessibility: AccessibilityConfiguration?
    }
    
    /// The accessbility wrapper info of this presentation item
    var accessibility: Accessibility?
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
            if let urlString = item.webImageUrl,
                let url = URL(string: urlString) {
                webImageUrl = url
            }
            return FactPresentationItem(title: titleText,
                                        body: bodyText,
                                        webImageUrl: webImageUrl,
                                        accessibility: itemAccessbility(item))
        }
        
        // A single section combining all elements
        let dataSections = [DataSection<FactPresentationItem>(items: presentationItems)]
        return DataSource<DataSection<FactPresentationItem>>(sections: dataSections)
    }
    
    private func itemAccessbility(_ input: Fact) -> FactPresentationItem.Accessibility {
        var titleAccessbility: AccessibilityConfiguration?
        var bodyAccessbility: AccessibilityConfiguration?
        var imageAccessbility: AccessibilityConfiguration?
        
        if let title = input.title {
            titleAccessbility = AccessibilityConfiguration(identifier: "accessibilityId.factsList.title",
                                                           label: UIAccessibility.createCombinedAccessibilityLabel(
                                                               from: ["Fact title", title]
                                                           ),
                                                           traits: .header)
        }
        
        if let body = input.description {
            bodyAccessbility = AccessibilityConfiguration(identifier: "accessibilityId.factsList.body",
                                                           label: UIAccessibility.createCombinedAccessibilityLabel(
                                                               from: ["Fact description", body]
                                                           ),
                                                           traits: .staticText)
        }
        
        if input.webImageUrl != nil {
            imageAccessbility = AccessibilityConfiguration(identifier: "accessibilityId.factsList.image",
                                                           label: "Fact image",
                                                           traits: .image)
        }
        return FactPresentationItem.Accessibility(titleAccessibility: titleAccessbility,
                                                  bodyAccessibility: bodyAccessbility,
                                                  imageAccessibility: imageAccessbility)
    }
}
