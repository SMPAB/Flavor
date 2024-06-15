//
//  Comment.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-13.
//

import Foundation
import Firebase

struct Comment: Identifiable, Hashable, Codable {
    let id: String
    let ownerUid: String
    
    var commentText: String
    let timestamp: Timestamp
    
    var likes: Int
    var subCommentsIds: [String]
    var subComment: Bool
    
    var isLiked: Bool? = false
    
    var primaryComment: String?
    var subCommentAnswerUsername: String?
    var subCommentAnswerCommentId: String?
    var user: User?
}
