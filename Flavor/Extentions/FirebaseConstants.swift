//
//  FirebaseConstants.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-12.
//

import Foundation
import FirebaseFirestore

struct FirebaseConstants{
    static let UserCollection = Firestore.firestore().collection("users")
    static let userNameCollection = Firestore.firestore().collection("usernames")
    
    static let PostCollection = Firestore.firestore().collection("posts")
    static let StoryCollection = Firestore.firestore().collection("storys")
    static let ChallengeUploadCollection = Firestore.firestore().collection("challengeUploads")
    
    static let CrewCollection = Firestore.firestore().collection("crews")
    static let ChallengeCollection = Firestore.firestore().collection("challenges")
    
    static let RecipeCollection = Firestore.firestore().collection("recipe")
    
    static let AlbumCollection = Firestore.firestore().collection("album")
    
    static let ReportsCollection = Firestore.firestore().collection("reports")
    
    
    static let FollowingCollection = Firestore.firestore().collection("following")
    static let FollowersCollection = Firestore.firestore().collection("followers")
}
