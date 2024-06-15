//
//  Album.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-15.
//

import Foundation
import Firebase

struct Album: Identifiable, Hashable, Codable {
    let id: String
    let ownerUid: String
    
    var imageUrl: String?
    let timestamp: Timestamp
    
    var title: String
    var uploadIds: [String]
    
}
