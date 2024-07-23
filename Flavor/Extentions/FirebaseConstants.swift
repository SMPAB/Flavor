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
    static let FeedCollection = Firestore.firestore().collection("feed")
    
    static let CrewCollection = Firestore.firestore().collection("crews")
    static let ChallengeCollection = Firestore.firestore().collection("challenges")
    
    static let PublicChallengeCollection = Firestore.firestore().collection("publicChallenges")
    
    static let PushNotificationCollectio = Firestore.firestore().collection("push-notifications")
    
    static let RecipeCollection = Firestore.firestore().collection("recipe")
    
    static let AlbumCollection = Firestore.firestore().collection("album")
    
    static let ReportsCollection = Firestore.firestore().collection("reports")
    
    
    static let FollowingCollection = Firestore.firestore().collection("following")
    static let FollowersCollection = Firestore.firestore().collection("followers")
}
