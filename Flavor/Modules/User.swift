//
//  User.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-11.
//

import Foundation
import Firebase

struct User: Identifiable, Hashable, Codable {
    let id: String
    let email: String
    var userName: String
    
    var biography: String?
    var profileImageUrl: String?
    
    var latestStory: String?
    var publicAccount: Bool
    
    var stats: UserStats?
    
    var hasSeenAllStorys: Bool? = false
    var hasFriendRequests: Bool? = false
    var isFollowed: Bool? = false
    var seenStory: Bool? = false
    
    var streak: Int? = 0
    var storys: [Story]?
    
    
    var postIds: [String]?
    
    var isCurrentUser: Bool{
        guard let currentUid = Auth.auth().currentUser?.uid else { return false}
        return currentUid == id
    }
}

struct UserStats: Codable, Hashable{
    var followingCount: Int
    var followersCount: Int
    var flavorCount: Int
}

extension User {
    static var mockUsers: [User] {
        return [
            .init(id: UUID().uuidString, email: "mock1@example.com", userName: "MockUser1", publicAccount: false),
            .init(id: UUID().uuidString, email: "mock2@example.com", userName: "MockUser2", publicAccount: true),
            .init(id: UUID().uuidString, email: "mock3@example.com", userName: "MockUser3", publicAccount: true),
            .init(id: UUID().uuidString, email: "mock4@example.com", userName: "MockUser4", publicAccount: true),
            .init(id: UUID().uuidString, email: "mock5@example.com", userName: "MockUser5", publicAccount: true)
        ]
    }
}
