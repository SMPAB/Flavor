//
//  ChallengeUpload.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-21.
//

import Foundation
import Firebase

struct ChallengeUpload: Identifiable, Hashable, Codable {
    let id: String
    let challengeId: String
    let ownerUid: String
    
    var storyId: String?
    var postId: String?
    
    var imageUrl: String?
    var timestamp: Timestamp
    
    var title: String
    
    var votes: Int
    
    var voters: [String]?
    
    var user: User?
}
