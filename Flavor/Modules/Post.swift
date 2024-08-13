//
//  Post.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-12.
//

import Foundation
import Firebase

struct Post: Identifiable, Hashable, Codable{
    let id: String
    let ownerUid: String
    let ownerUsername: String
    
    var likes: Int
    
    var title: String?
    var caption: String?
    var imageUrls: [String]?
    var Albums: [String]?
    
    var storyID: String?
    let recipeId: String?
    var challengeUploadId: String?
    var locationId: String?
    var locationTitle: String?
    
    var pinned: Bool? = false
    
    var publicPost: Bool? = false
    
    let timestamp: Timestamp
    let timestampDate: String
    
    var hasLiked: Bool? = false
    var hasSaved: Bool? = false
    
    var user: User?
}

extension Post {
    static var mockPosts: [Post] {
        return [
            .init(id: "001", ownerUid: "1234", ownerUsername: "EmilioMz", likes: 10, title: "What a nice day", caption: "Today I took the time to discover one of stockholms finest food courts, lokated in mall of scandinavio!!!", imageUrls: ["https://firebasestorage.googleapis.com:443/v0/b/favoorswiftui.appspot.com/o/profile_images%2F440C3648-5044-4C03-9327-438D8BB5A09B?alt=media&token=4f9d4b25-035a-4d8d-8b15-9281659a0d78", "https://firebasestorage.googleapis.com:443/v0/b/favoorswiftui.appspot.com/o/profile_images%2F440C3648-5044-4C03-9327-438D8BB5A09B?alt=media&token=4f9d4b25-035a-4d8d-8b15-9281659a0d78", "https://firebasestorage.googleapis.com:443/v0/b/favoorswiftui.appspot.com/o/profile_images%2F6FC21E89-B6E2-4F19-9F3A-9E9E0391271E?alt=media&token=f653bf43-ca37-496e-b229-3fbd2e986436", "1231"

], storyID: nil, recipeId: nil, timestamp: Timestamp(date: Date()), timestampDate: "Feb21", user: User.mockUsers[0])
        ]
    }
}
