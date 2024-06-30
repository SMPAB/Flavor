//
//  Crew.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-19.
//

import Foundation
import Firebase

struct Crew: Identifiable, Hashable, Codable {
    let id: String
    var admin: String
    var crewName: String
    
    var imageUrl: String?
    let creationDate: Timestamp
    var publicCrew: Bool
  
    var uids: [String]
    var userRating: [String: UserRating]?
    
    var challengeIds: [String]? = []
}

struct UserRating: Identifiable, Codable, Hashable {
    var id: String  // This can be the username
    var points: Int
    var wins: [String]
    var user: User?
    // Conform to Identifiable protocol
    //var uuid: UUID { UUID() }
}

