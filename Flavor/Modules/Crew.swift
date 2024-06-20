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
}
