//
//  CountryFactsDisplay.swift
//  MyCountry
//
//  Created by Arinjoy Biswas on 11/4/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation

protocol FactsListDisplay: class {
    
    /// Will set the view title in navigation bar
    ///
    /// - Parameter title: The title to set
    func setTitle(_ title: String)
    
    /// Will display the given data source as the primary display to set
    ///
    /// - Parameter dataSource: The set of formatted data to display (transformed view models)
    func setFactsListDataSource(_ dataSource: FactsListDataSource)
    
    /// Will show loading indicator while facts are being fetched
    func showLoadingIndicator()
    
    /// Will hide the loading indicator
    func hideLoadingIndicator()
    
    /// Will show an error alert
    func showError(title: String, message: String, dismissTitle: String)
}
