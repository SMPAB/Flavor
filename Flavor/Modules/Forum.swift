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
    var newUserId: String?
    
    //NEW CHALLEGNE
    var challengeID: String?
    
    
    //VOTING
    var Upvotes: Int? = 0
    var DownVotes: Int? = 0
    var isLiked: Bool? = false
    var isDisliked: Bool? = false
    
    
    //Anouncement
    var announcementText: String?
    var announcementTextOwnerId: String?
    
    
    var challenge: Challenge?
    var user: User?
}
