//
//  Recipe.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-17.
//

import Foundation

struct Recipe: Identifiable, Hashable, Codable {
    let id: String
    var ownerPost: String
    var name: String
    var difficualty: Int
    var time: String
    var servings: Int
    var ingrediences: [ingrediences]
    var steps: [steps]
    var utensils: [utensil]
    
    var imageUrl: String?
}

struct steps: Hashable, Codable{
    var stepNumber: Int
    var text: String
    var utensils: [utensil]
    var ingrediences: [ingrediences]
}

struct ingrediences: Hashable, Codable{
    var units: Int
    var ingredient: String
    var messurment: String
}

struct utensil: Hashable, Codable{
    var utensil: String
}
