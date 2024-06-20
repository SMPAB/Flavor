//
//  Recipe.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-17.
//

import Foundation

struct Recipe: Identifiable, Hashable, Codable {
    let id: String
    let ownerUid: String
    var publicRecipe: Bool
    var ownerPost: String
    
    var name: String
    var difficualty: Int
    var time: String
    var servings: Int
    var ingrediences: [ingrediences]
    var steps: [steps]
    var utensils: [utensil]
    
    var imageUrl: String?
    
    var isSaved: Bool? = false
    
    var user: User?
}

struct steps: Hashable, Codable{
    var stepNumber: Int
    var text: String
    var utensils: utensil
    var ingrediences: [ingrediences]
}

struct ingrediences: Hashable, Codable{
    var units: String
    var ingredient: String
    var messurment: String
}

struct utensil: Hashable, Codable{
    var utensil: String
}
