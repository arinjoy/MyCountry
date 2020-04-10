//
//  File.swift
//  MyCountry
//
//  Created by Arinjoy Biswas on 10/4/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import Foundation

/// A data structure that has a list of facts about some entity or subject
struct FactsList: Decodable {
    
    /// The title/name of the main subject or the entity about the facts this struct represents
    let title: String
    
    /// An array of facts abou the subject
    let facts: [Fact]
    
    // MARK: - Coding key mapping
    
    enum CodingKeys: String, CodingKey {
        case title
        case facts = "rows"
    }
}

/// A data structure about a fact of something
struct Fact: Decodable {
    
    /// The (optional) title of the fact
    let title: String?
    
    /// The (optional) description of the fact
    let description: String?
    
    /// The (optional) image web URL string of the fact
    let imageUrl: String?
        
    // MARK: - Coding key mapping
    
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case imageUrl = "imageHref"
    }
}
