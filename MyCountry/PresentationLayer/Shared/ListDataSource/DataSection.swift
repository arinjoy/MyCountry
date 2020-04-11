//
//  DataSection.swift
//  MyCountry
//
//  Created by Arinjoy Biswas on 11/4/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation

/// Instances conforming to the `DataSectionProtocol` will represent
/// a section of items with an optional header or footer title.
protocol DataSectionProtocol {

    // MARK: - Associated type

    associatedtype Item

    // MARK: - Properties

    /// Optional identifier for use with `Equatable` and `Hashable`
    var identifier: String? { get set }

    /// The items managed by the section
    var items: [Item] { get set }

    /// The header title for the section
    var headerTitle: String? { get }

    /// The footer title for the section
    var footerTitle: String? { get }
}

/// A concrete `DataSectionProtocol` instance
struct DataSection<Item>: DataSectionProtocol, Hashable {
    
    // MARK: - Properties

    /// Optional identifier for the section
    var identifier: String?

    /// The items in the section.
    var items: [Item]

    /// The header title for the section
    let headerTitle: String?

    /// The footer title for the section
    let footerTitle: String?

    /// The total number of items currently in the section
    var count: Int {
        return items.count
    }

    // MARK: - Lifecycle

    /// Will return a new `Section` struct.
    ///
    /// - Parameters:
    ///   - items: The items to manage
    ///   - headerTitle: The header title string
    ///   - footerTitle: The footer title string
    ///   - identifier: Optional section identifier
    init(
        items: [Item],
        headerTitle: String? = nil,
        footerTitle: String? = nil,
        identifier: String? = nil
    ) {
        self.items = items
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.identifier = identifier
    }

    // MARK: - Subscript

    /// Subscript logic
    ///
    /// - Parameter index: The index of the item to return
    /// - Returns: The item at the given `index`
    subscript(index: Int) -> Item {
        get {
            return items[index]
        }
        set {
            items[index] = newValue
        }
    }

    /**
     Note: Because of the generic types the diffable has to be conformed to on this concrete struct. An extension
     would not register and can't be declared appropriately.
     */

    // MARK: - Diffable/Hashable

    var hashValue: Int {
        return identifier?.hashValue ?? 0
    }

    static func == (lhs: DataSection<Item>, rhs: DataSection<Item>) -> Bool {
        guard lhs.headerTitle == rhs.headerTitle && lhs.footerTitle == rhs.footerTitle else {
            return false
        }
        guard let leftItems = lhs.items as? [AnyHashable], let rightItems = rhs.items as? [AnyHashable] else {
            return false
        }
        return leftItems == rightItems
    }
}
