//
//  Forum.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-30.
//

import Foundation
import Firebase

struct Forum: Identifiable, Hashable, Codable {
    let id: String
    let type: ForumType
    let timestamp: Timestamp
    
    //NEW USER
    var userId: String?
    
    //NEW CHALLEGNE
    var challengeID: String?
}
