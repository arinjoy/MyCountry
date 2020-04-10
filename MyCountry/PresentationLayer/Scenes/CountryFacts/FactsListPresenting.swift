//
//  FactsListPresenting.swift
//  MyCountry
//
//  Created by Arinjoy Biswas on 11/4/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation

protocol FactsListPresenting: class {
    
    /// Called when view did become ready
    func viewDidBecomeReady()
    
    /// Will facts of something to be diplayed
    ///
    /// - Parameter isRereshingNeeded: Whether data regreshing is needed
    func loadFacts(isRereshingNeeded: Bool)
}
