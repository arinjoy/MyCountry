//
//  DataSource.swift
//  MyCountry
//
//  Created by Arinjoy Biswas on 11/4/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation

/// An instance conforming to the `DataSourceProtocol` will represent a source of items
/// to be displayed in either a `UICollectionView` or `UITableView`
protocol DataSourceProtocol {

    // MARK: Associated type

    /// The type of items in the data source
    associatedtype Item

    // MARK: - Getters

    /// The total number of sections
    ///
    /// - Returns: Int
    func numberOfSections() -> Int

    /// Will return the total number of items in the section at the given index
    ///
    /// - Parameter section: The index of the section
    /// - Returns: Int
    func numberOfItems(inSection section: Int) -> Int

    /// Will return the items in the section at the given index
    ///
    /// - Parameter section: The section index
    /// - Returns: Array or `nil`.
    func items(inSection section: Int) -> [Item]?

    /// Will return the item at the given `row` inside the section at the given index
    ///
    /// - Parameters:
    ///   - row: The index of the item
    ///   - section: The index of the section
    /// - Returns: Item or `nil`.
    func item(atRow row: Int, inSection section: Int) -> Item?

    /// Will return the currently stored `headerTitle` for the section at the given index
    ///
    /// - Parameter section: The section index
    /// - Returns: String or `nil`
    func headerTitle(forSection section: Int) -> String?

    /// Will return the currently stored `footerTitle` for the section at the given index
    ///
    /// - Parameter section: The section index
    /// - Returns: String or `nil`
    func footerTitle(forSection section: Int) -> String?
}

// MARK: - Default DataSourceProtocol behaviours

extension DataSourceProtocol {

    /// Will return the item at the given `indexPath` within the data source
    ///
    /// - Parameter indexPath: The index path of the item to retrieve
    /// - Returns: Item or `nil`
    func item(atIndexPath indexPath: IndexPath) -> Item? {
        return item(atRow: indexPath.row, inSection: indexPath.section)
    }
}

/// A concrete `DataSource` instance that can handle the majority of table/collection data structures.
struct DataSource<Section: DataSectionProtocol>: DataSourceProtocol {

    // MARK: - Public properties

    /// An array of sections managed by the data source.
    var sections: [Section]

    // MARK: - Lifecycle

    /// Will initialize a new DataSource with the given sections.
    ///
    /// - Parameter sections: The sections to manage. Default is empty.
    init(sections: [Section] = []) {
        self.sections = sections
    }

    // MARK: - DataSourceProtocol

    func numberOfSections() -> Int {
        return sections.count
    }

    func numberOfItems(inSection section: Int) -> Int {
        guard section < sections.count else { return 0 }
        return sections[section].items.count
    }

    func items(inSection section: Int) -> [Section.Item]? {
        guard section < sections.count else { return nil }
        return sections[section].items
    }

    func item(atRow row: Int, inSection section: Int) -> Section.Item? {
        guard let items = items(inSection: section) else { return nil }
        guard row < items.count else { return nil }
        return items[row]
    }

    func headerTitle(forSection section: Int) -> String? {
        guard section < sections.count else { return nil }
        return sections[section].headerTitle
    }

    func footerTitle(forSection section: Int) -> String? {
        guard section < sections.count else { return nil }
        return sections[section].footerTitle
    }

    // MARK: - Convenience helpers

    /// Will return whether or not there is a valid header title for the given section.
    ///
    /// - Parameters:
    ///   - section: The section to search in
    ///   - excludeEmpty: Bool whether to treat an empy string as nil
    /// - Returns: Bool
    func hasHeaderTitle(forSection section: Int, excludeEmpty: Bool = true) -> Bool {
        guard let title = headerTitle(forSection: section) else { return false }
        return (excludeEmpty && title.isEmpty) ? false : true
    }

    /// Will return whether or not there is a valid footer title for the given section.
    ///
    /// - Parameters:
    ///   - section: The section to search in
    ///   - excludeEmpty: Bool whether to treat an empy string as nil
    /// - Returns: Bool
    func hasFooterTitle(forSection section: Int, excludeEmpty: Bool = true) -> Bool {
        guard let title = footerTitle(forSection: section) else { return false }
        return (excludeEmpty && title.isEmpty) ? false : true
    }

    // MARK: - Section mutators

    /// Will add the given section to the sections array.
    ///
    /// - Parameters:
    ///   - section: The section to insert
    mutating func append(section: Section) {
        sections.append(section)
    }

    /// Will insert the given section at the given index.
    ///
    /// - Parameters:
    ///   - section: The section to insert
    ///   - index: The index to insert at
    mutating func insert(section: Section, at index: Int) {
        if index < 0 {
            sections.insert(section, at: 0)
        } else if index < sections.count {
            sections.insert(section, at: index)
        } else {
            sections.append(section)
        }
    }

    /// Will insert the given section at the given index.
    ///
    /// - Parameters:
    ///   - section: The section to insert
    ///   - index: The index to insert at
    mutating func removeSection(at index: Int) {
        guard index < numberOfSections() else { return }
        sections.remove(at: index)
    }

    /// Will remove and return the last section in the data source
    ///
    /// - Returns: `Section`
    @discardableResult
    mutating func popLast() -> Section? {
        return sections.popLast()
    }

    // MARK: - Item mutators

    /// Will insert the given item at the given `IndexPath`
    ///
    /// - Parameters:
    ///   - item: The item to insert
    ///   - indexPath: The `IndexPath` to insert at
    mutating func insert(item: Section.Item, at indexPath: IndexPath) {
        insert(item: item, atRow: indexPath.row, inSection: indexPath.section)
    }

    /// Will insert the given item at the given row in the section at the given index
    ///
    /// - Parameters:
    ///   - item: The item to insert
    ///   - row: The row index to insert at
    ///   - section: The index of the section to insert into
    mutating func insert(item: Section.Item, atRow row: Int, inSection section: Int) {
        guard section < numberOfSections() else { return }
        guard row <= numberOfItems(inSection: section) else { return }
        sections[section].items.insert(item, at: row)
    }

    /// Will append the given item to the items of the section at the given index.
    ///
    /// - Parameters:
    ///   - item: The item to append
    ///   - section: The index of the section to append to
    mutating func append(item: Section.Item, in section: Int) {
        guard let items = items(inSection: section) else { return }
        insert(item: item, atRow: items.endIndex, inSection: section)
    }

    /// Will replace the given item at the given `IndexPath`
    ///
    /// - Parameters:
    ///   - item: The item to replace
    ///   - indexPath: The `IndexPath` to replace at
    mutating func replace(item: Section.Item, at indexPath: IndexPath) {
        removeItem(at: indexPath)
        insert(item: item, at: indexPath)
    }

    /// Will remove the item at the given `IndexPath` from the `DataSource`
    ///
    /// - Parameter indexPath: The `IndexPath` of the item to remove
    /// - Returns: discardable Item or `nil`
    @discardableResult
    mutating func removeItem(at indexPath: IndexPath) -> Section.Item? {
        return removeItem(atRow: indexPath.row, inSection: indexPath.section)
    }

    /// Will remove the item at the given row in the section at the given index from the `DataSource`
    ///
    /// - Parameters:
    ///   - row: The index of the item to remove
    ///   - section: The index of the section that contains the item
    /// - Returns: discardable Item or `nil`
    @discardableResult
    mutating func removeItem(atRow row: Int, inSection section: Int) -> Section.Item? {
        guard item(atRow: row, inSection: section) != nil else { return nil }
        return sections[section].items.remove(at: row)
    }

    /// Will remove the last item in the given section from the `DataSource`
    ///
    /// - Parameter section: The index of the section
    /// - Returns: discardable Item or `nil`
    @discardableResult
    mutating func popItem(inSection section: Int) -> Section.Item? {
        guard let items = items(inSection: section), items.count > 0 else { return nil }
        return removeItem(atRow: (items.count - 1), inSection: section)
    }

    // MARK: Subscript

    /// Will return the section at the given index
    ///
    /// - Parameter index: The index of a section.
    /// - Returns: The section at the `index`
    subscript(index: Int) -> Section {
        get {
            return sections[index]
        }
        set {
            sections[index] = newValue
        }
    }

    /// Will return the item at the given `IndexPath`
    ///
    /// - Parameter indexPath: The `IndexPath` of the item
    /// - Returns: The item at the `indexPath`
    subscript(indexPath: IndexPath) -> Section.Item {
        get {
            return sections[indexPath.section].items[indexPath.row]
        }
        set {
            sections[indexPath.section].items[indexPath.row] = newValue
        }
    }
}
