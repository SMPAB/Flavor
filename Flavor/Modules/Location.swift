//
//  Location.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-07-26.
//

import Foundation

struct Location: Identifiable, Hashable, Codable {
    let id: String
    var storyIds: [String]?
    var postIds: [String]?
    var rating: Double?
    var raters: Int?
    var reviews: Int?
    
    var name: String?
}
