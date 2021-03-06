//
//  FactsList.swift
//  MyCountry
//
//  Created by Arinjoy Biswas on 10/4/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation

/// A data structure that has a list of facts about some entity or subject
struct FactsList: Decodable {
    
    /// The title/name of the main subject or the entity about the facts this struct represents
    let subjectName: String
    
    /// An array of facts about the subject
    let facts: [Fact]
    
    // MARK: - Coding key mapping
    
    enum CodingKeys: String, CodingKey {
        case subjectName = "title"
        case facts = "rows"
    }
    
    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: CodingKeys.self)
        self.subjectName = try map.decode(String.self, forKey: .subjectName)
        let facts = try map.decode([Fact].self, forKey: .facts)
        
        // Make sure all facts in the array are valid.
        // A fact is only valid if at least one of the (title, description, imageUrl) is non-nil
        // If all three attributes are nil, then just discard such void/redundant fact
        self.facts = facts.filter { !($0.title == nil && $0.description == nil && $0.webImageUrl == nil) }
    }
    
    init(subjectName: String, facts: [Fact]) {
        self.subjectName = subjectName
        self.facts = facts
    }
}

/// A data structure about a fact of something
struct Fact: Decodable {
    
    /// The (optional) title of the fact
    let title: String?
    
    /// The (optional) description of the fact
    let description: String?
    
    /// The (optional) image web URL string of the fact
    let webImageUrl: String?
        
    // MARK: - Coding key mapping
    
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case webImageUrl = "imageHref"
    }
}
