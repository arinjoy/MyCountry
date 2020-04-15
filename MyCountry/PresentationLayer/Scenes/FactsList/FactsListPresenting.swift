//
//  FactsListPresenting.swift
//  MyCountry
//
//  Created by Arinjoy Biswas on 11/4/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation
import UIKit

protocol FactsListPresenting: class {
    
    /// The tranformed list data source with presentation items to bind to a list UI
    var factsListDataSource: FactsListDataSource { get set }
    
    /// A cache/store of images loaded for facts to bind to the list cells
    var factsImageStore: [IndexPath: UIImage?] { get set }
    
    /// Will load facts of something to be diplayed
    ///
    /// - Parameter isRereshingNeeded: Whether data refreshing is needed
    func loadFacts(isRereshingNeeded: Bool)
      
    // MARK: - Image Loading Related
    
    /**
     UIKit independent behaviours:
     `UIImage` is just being passed as a data packet only, and hence referred from `UIKit` module here.
     Technically, we could have passed a different type, such as  raw`Data` (or maybe `CGIImage`) here to avoid `UIImage` type.
     The core of this presenter logic is still `UIKit` <events/controls/delegates etc.> independent .
     */
    
    /// Will add an image loading opeation at a specified indexPath (if not already added)
    /// - Parameters:
    ///   - indexPath: indexPath to add the loader
    ///   - updateCellClosure: A closure to execute when image loading is completed
    func addImageLoadOperation(atIndexPath indexPath: IndexPath, updateCellClosure: ((UIImage?) -> Void)?)
    
    /// Will remove an image loading opeation at a specified indexPath (if exists)
    /// - Parameters:
    ///   - indexPath: indexPath to add the loader
    func removeImageLoadOperation(atIndexPath indexPath: IndexPath)
}
