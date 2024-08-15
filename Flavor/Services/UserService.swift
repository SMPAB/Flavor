//
//  UserService.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-12.
//

import SwiftUI
import Foundation
import FirebaseFirestore
import Firebase

class UserService{
    
    static func fetchUser(withUid uid: String) async throws -> User{
        return try await FirebaseConstants.UserCollection.document(uid).getDocument().data(as: User.self)
    }
    
    static func fetchOptionalUser(withUid uid: String) async throws ->User?{
        do {
            return try await FirebaseConstants.UserCollection.document(uid).getDocument().data(as: User.self)
        } catch {
            return nil
        }
    }
    
    static func fetchAllUsernames() async throws -> [String]{
        do {
            let snapshot = try await Firestore
                .firestore()
                .collection("usernames")
                .document("batch1")
                .getDocument()
            
            if let usernames = snapshot.data()?["usernames"] as? [String]{
                let lowercasedUsernames = usernames.map { $0.lowercased()}
                return lowercasedUsernames
            } else {
                return []
            }
        } catch {
            return []
        }
        
        
    }
    
    @MainActor
    static func fetchAllUsernamesNoLowercase() async throws -> [String]{
        do {
            let snapshot = try await Firestore
                .firestore()
                .collection("usernames")
                .document("batch1")
                .getDocument()
            
            let usersNotToShow = try await usersToNotShow()
            
            //print("DEBUG APP USERSNOT TO SHOW: \(usersNotToShow)")
            
            if let usernames = snapshot.data()?["usernames"] as? [String]{
                let filteredUsernames = usernames.filter { !usersNotToShow.contains($0) }
                        return filteredUsernames
            } else {
                return []
            }
        } catch {
            return []
        }
    }
    
    @MainActor
        static func fetchUserWithUsername(withUsername username: String) async throws -> User? {
            
            do {
                let querySnapshot = try await FirebaseConstants
                    .UserCollection
                    .whereField("userName", isEqualTo: username)
                    .getDocuments()

               
                
                guard let document = querySnapshot.documents.first else {return nil}

                
                return try document.data(as: User.self)
            } catch {
                return nil
            }
            
        }
        
        @MainActor
        static func fetchUserFollowingUsernames(id: String) async throws -> [String]{
            do {
                let documentSnapshot = try await FirebaseConstants
                            .FollowingCollection
                            .document(id)
                            .collection("user-followingUsername")
                            .document("batch1")
                            .getDocument()
                
                let usersToNotShow = try await usersToNotShow()
                
                if let usernames = documentSnapshot.data()?["usernames"] as? [String] {
                    let filteredUsernames = usernames.filter { !usersToNotShow.contains($0) }
                            return filteredUsernames
                        } else {
                            return []
                        }
            } catch {
                return []
            }
        }
    
   
    
    @MainActor
    static func fetchUserFollowersUsernames(id: String) async throws -> [String]{
        do {
            let documentSnapshot = try await FirebaseConstants
                        .FollowersCollection
                        .document(id)
                        .collection("user-followersUsername")
                        .document("batch1")
                        .getDocument()
            
            let usersToNotShow = try await usersToNotShow()
            
            
            if let usernames = documentSnapshot.data()?["usernames"] as? [String] {
                let filteredUsernames = usernames.filter { !usersToNotShow.contains($0) }
                        return filteredUsernames
                    } else {
                        return []
                    }
        } catch {
            return []
        }
    }
    
    @MainActor
    static func fetchRecomendedUsers() async throws -> [User] {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return []}
        do {
           let snapshot = try await FirebaseConstants
                .UserCollection
                .whereField("publicAccount", isEqualTo: true)
                .limit(to: 5)
                .getDocuments()
            
            let users = snapshot.documents.compactMap({try? $0.data(as: User.self)}).filter({$0.id != currentUid})
            return users
            
        } catch {
            return []
        }
    }
    
    
    @MainActor
    static func usersToNotShow() async throws -> [String]{
        do {
            guard let currentUid = Auth.auth().currentUser?.uid else { return [] }
            
            var usersToNotShow: [String] = []
            
            // Retrieving users who have blocked the current user
            let beenBlocked = try await FirebaseConstants
                .UserCollection
                .document(currentUid)
                .collection("block")
                .document("been_blocked")
                .getDocument()
            
            if let beenBlockedUsernames = beenBlocked.data()?["usernames"] as? [String] {
                usersToNotShow.append(contentsOf: beenBlockedUsernames)  // Corrected line
            }
            
            // Fetching usernames, assuming usersToNotShow would be used to filter these usernames.
            let hasBlocked = try await FirebaseConstants
                .UserCollection
                .document(currentUid)
                .collection("block")
                .document("has_blocked")
                .getDocument()
            
            if let usernames = hasBlocked.data()?["usernames"] as? [String] {
                usersToNotShow.append(contentsOf: usernames)
                return usersToNotShow
            } else {
                return []
            }
        } catch {
            return []
        }

    }
        
}
//MARK: STATS
extension UserService{
    static func fetchUserStats(_ uid: String) async throws -> UserStats? {
        
        var userStats = UserStats(followingCount: 0, followersCount: 0, flavorCount: 0)
        
        do {
            let snapshot = try await FirebaseConstants
                .FollowersCollection
                .document(uid)
                .collection("user-followersUsername")
                .document("batch1")
                .getDocument()
            
            let followers = snapshot.data()?["usernames"] as? [String]
            userStats.followersCount = followers?.count ?? 0
            
            let snapshot2 = try await FirebaseConstants
                .FollowingCollection
                .document(uid)
                .collection("user-followingUsername")
                .document("batch1")
                .getDocument()
            
            let following = snapshot2.data()?["usernames"] as? [String]
            userStats.followingCount = followers?.count ?? 0
            
            return userStats
        } catch {
            return nil
        }
        
        
        
    }
}
//MARK: USERFOLLOWING
extension UserService {
    static func checkIfUserIsFollowing(_ userId: String) async throws -> Bool {
        guard let uid = Auth.auth().currentUser?.uid else { return false}
        
        do {
            let snapshot = try await FirebaseConstants
                .FollowersCollection
                .document(userId)
                .collection("user-followersID")
                .document(uid)
                .getDocument()
            
            
            return snapshot.exists
        } catch {
            return false
        }
    }
    
    static func checkIfUserHasFriendRequest(_ userId: String) async throws -> Bool {
        guard let uid = Auth.auth().currentUser?.uid else { return false}
        
        do {
            let snapshot = try await FirebaseConstants
                .FollowersCollection
                .document(userId)
                .collection("friend-requestID")
                .document(uid)
                .getDocument()
            
            return snapshot.exists
        } catch {
            return false
        }
    }
    
    static func follow(userToFollow: User, userFollowing: User) async throws{
        
        //SET DATA TO THE USER THAT IS BEING FOLLOWED
       async let _ = try await FirebaseConstants
            .FollowersCollection
            .document(userToFollow.id)
            .collection("user-followersID")
            .document(userFollowing.id)
            .setData([:])
        
        async let _ = try await FirebaseConstants
            .FollowersCollection
            .document(userToFollow.id)
            .collection("user-followersUsername")
            .document("batch1")
            .setData(["usernames": FieldValue.arrayUnion([userFollowing.userName])], merge: true)
        
        //SET DATA TO THE USER FOLLOWING
        async let _ = try await FirebaseConstants
            .FollowingCollection
            .document(userFollowing.id)
            .collection("user-followingID")
            .document(userToFollow.id)
            .setData([:])
        
        async let _ = try await FirebaseConstants
            .FollowingCollection
            .document(userFollowing.id)
            .collection("user-followingUsername")
            .document("batch1")
            .setData(["usernames": FieldValue.arrayUnion([userToFollow.userName])], merge: true)
    }
    
    static func unfollow(userToUnfollow: User, userUnfollowing: User) async throws{
        //DELETE TO THE USER THAT IS BEING FOLLOWED
       async let _ = try await FirebaseConstants
            .FollowersCollection
            .document(userToUnfollow.id)
            .collection("user-followersID")
            .document(userUnfollowing.id)
            .delete()
        
        async let _ = try await FirebaseConstants
            .FollowersCollection
            .document(userToUnfollow.id)
            .collection("user-followersUsername")
            .document("batch1")
            .updateData(["usernames": FieldValue.arrayRemove([userUnfollowing.userName])])
        
        //SET DATA TO THE USER FOLLOWING
        async let _ = try await FirebaseConstants
            .FollowingCollection
            .document(userUnfollowing.id)
            .collection("user-followingID")
            .document(userToUnfollow.id)
            .delete()
        
        async let _ = try await FirebaseConstants
            .FollowingCollection
            .document(userUnfollowing.id)
            .collection("user-followingUsername")
            .document("batch1")
            .updateData(["usernames": FieldValue.arrayRemove([userToUnfollow.userName])])
    }
    
    static func sendFriendRequest(userToSendFriendRequestTo: User, userSending: User) async throws{
        //SET DATA TO THE USER THAT IS BEING FOLLOWED
       async let _ = try await FirebaseConstants
            .FollowersCollection
            .document(userToSendFriendRequestTo.id)
            .collection("friend-requestID")
            .document(userSending.id)
            .setData([:])
        
        async let _ = try await FirebaseConstants
            .FollowersCollection
            .document(userToSendFriendRequestTo.id)
            .collection("friend-requestUsername")
            .document("batch1")
            .setData(["usernames": FieldValue.arrayUnion([userSending.userName])], merge: true)
        
    }
    
    static func removeFriendRequest(userToRemoveFrom: User, userRemoving: User) async throws{
        //DELETE TO THE USER THAT IS BEING FOLLOWED
       async let _ = try await FirebaseConstants
            .FollowersCollection
            .document(userToRemoveFrom.id)
            .collection("friend-requestID")
            .document(userRemoving.id)
            .delete()
        
        async let _ = try await FirebaseConstants
            .FollowersCollection
            .document(userToRemoveFrom.id)
            .collection("friend-requestUsername")
            .document("batch1")
            .updateData(["usernames": FieldValue.arrayRemove([userRemoving.userName])])
    }
}

//MARK: Albums
extension UserService {
    static func fetchUserAlbums(_ user: User, latestDocument: DocumentSnapshot? = nil) async throws -> ([Album], DocumentSnapshot?){
        do {
            var query: Query = FirebaseConstants
                .AlbumCollection
                .whereField("ownerUid", isEqualTo: user.id)
                .limit(to: 10)
            
            
            if let lastDocument = latestDocument {
                query = query.start(afterDocument: lastDocument)
            }
            
            let snapshot = try await query.getDocuments()
            
           
            var albums = snapshot.documents.compactMap({ try? $0.data(as: Album.self)})
            for i in 0..<albums.count {
                albums[i].user = user
            }
            let latestSnapshot = snapshot.documents.last
            
            return (albums, latestDocument)
        } catch {
            return ([], latestDocument)
        }
    }
}

//MARK: BLOCK
extension UserService {
    static func blockUser(user: User, currentUser: User) async throws {
        do {
            //MARK: HAS BLOCKED
            
            try await FirebaseConstants
                .UserCollection
                .document(currentUser.id)
                .collection("block")
                .document("has_blocked")
                .setData(["usernames": FieldValue.arrayUnion([user.userName])], merge: true)
            
            
            //MARK: BEEN BLOCKED
            
            try await FirebaseConstants
                .UserCollection
                .document(user.id)
                .collection("block")
                .document("been_blocked")
                .setData(["usernames": FieldValue.arrayUnion([currentUser.userName])], merge: true)
            
        } catch {
            return
        }
    }
    
    static func report(reportText: String, user: User) async throws {
        do {
            
            var data: [String:Any] = [
                "reportText": reportText,
                "userId": user.id,
                "timestamp": Timestamp(date: Date())
            ]
            try await FirebaseConstants
                .ReportsCollection
                .document("accounts")
                .collection("accounts")
                .document()
                .setData(data)
        } catch {
            return
        }
    }
    
    
}
//MARK: NOTFICAITONS
extension UserService {
    static func fetchFriendRequestUsernames() async throws -> [String]{
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return []}
        do {
            
            let snapshot = try await FirebaseConstants
                .FollowersCollection
                .document(currentUid)
                .collection("friend-requestUsername")
                .document("batch1")
                .getDocument()
            
            if let usernames = snapshot.data()?["usernames"] as? [String]{
                return usernames
            } else {
                return []
            }
        } catch {
            return []
        }
    }
}

//MARK: - SETTINGS

extension UserService {
    static func fetchBlockedUsers() async throws -> [String]{
        guard let uid = Auth.auth().currentUser?.uid else { return []}
        
        do {
            let snapshot = try await FirebaseConstants
                .UserCollection
                .document(uid)
                .collection("block")
                .document("has_blocked")
                .getDocument()
            
            if let usernames = snapshot.data()?["usernames"] as? [String] {
                return usernames
            } else {
                return []
            }
        } catch {
            return []
        }
    }
    
    static func unblock(userToUnblock: User, currentUser: User) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        do {
            try await FirebaseConstants
                .UserCollection
                .document(uid)
                .collection("block")
                .document("has_blocked")
                .updateData(["usernames": FieldValue.arrayRemove([userToUnblock.userName])])
            
            
            try await FirebaseConstants
                .UserCollection
                .document(userToUnblock.id)
                .collection("block")
                .document("been_blocked")
                .updateData(["usernames": FieldValue.arrayRemove([currentUser.userName])])
            
            
            
        } catch {
            
        }
    }
}

//MARK: - DELETE

extension UserService{
    static func deleteAccount(_ user: User) async throws {
        
        do {
            
            //MARK: DELETE ALL CHALLENGPOST USER HAS
            
            let challengeSnapshot = try await FirebaseConstants
                .ChallengeCollection
                .whereField("users", arrayContains: user.id)
                .getDocuments()
            
            let challenges = challengeSnapshot.documents.compactMap({try? $0.data(as: Challenge.self)})
            
            for i in 0..<challenges.count {
                let challenge = challenges[i]
                let challengePostsSnap = try await FirebaseConstants.ChallengeCollection.document(challenge.id).collection("posts").whereField("ownerUid", isEqualTo: user.id).getDocuments()
                
                let challengePostsIds = challengePostsSnap.documents.map {$0.documentID}
                
                for challengePostsId in challengePostsIds {
                    try await FirebaseConstants.ChallengeCollection.document(challenge.id).collection("posts").document(challengePostsId).delete()
                }
            }
            
            //MARK: FETCH ALL CREWS USER IS IN, REMOVE FROM CREW
            
            try await leaveCrew(user)
            
            
            //MARK: DELETE USERNAME FROM BACKEND
            try await FirebaseConstants.userNameCollection.document("batch1").setData(["usernames": FieldValue.arrayRemove([user.userName])], merge: true)
            
            //MARK: FETCH ALL USERFOLLOWERS, GO INTO THERE USER FOLLOWING AND DELETEE USERNAME, ID,
            
            let followingSnapshot = try await FirebaseConstants.FollowingCollection.document(user.id).collection("user-followingID").getDocuments()
            let followingIDs = followingSnapshot.documents.map { $0.documentID }
            
            for followingID in followingIDs {
                try await FirebaseConstants.FollowersCollection.document(followingID).collection("user-followersUsername").document("batch1").setData(["usernames": FieldValue.arrayRemove([user.userName])], merge: true)
                
                try await FirebaseConstants.FollowersCollection.document(followingID).collection("user-followersID").document(user.id).delete()
                
                try await FirebaseConstants.FollowersCollection.document(followingID).collection("friend-requestID").document("batch1").setData(["ids": FieldValue.arrayRemove([user.id])], merge: true)
                
                try await FirebaseConstants.FollowersCollection.document(followingID).collection("friend-requestUsername").document("batch1").setData(["usernames": FieldValue.arrayRemove([user.userName])], merge: true)
                
                try await FirebaseConstants.FollowersCollection.document(followingID).collection("friend-requestID").document(user.id).delete()
                
                
            }
            
            
            
            //MARK: FETCH ALL USERFOLLOWING, UNFOLLOW ALL USERS
            
            let followersSnapshot = try await FirebaseConstants.FollowersCollection.document(user.id).collection("user-followersID").getDocuments()
            let followersIDS = followersSnapshot.documents.map {$0.documentID}
            
            for followerID in followersIDS {
                try await FirebaseConstants.FollowingCollection.document(followerID).collection("user-followingID").document(user.id).delete()
                
                try await FirebaseConstants.FollowingCollection.document(followerID).collection("user-followingUsername").document("batch1").setData(["usernames": FieldValue.arrayRemove([user.userName])], merge: true)
            }
            
            try await FirebaseConstants.FollowingCollection.document(user.id).delete()
            try await FirebaseConstants.FollowersCollection.document(user.id).delete()
            
            //MARK: DELETE POSTS IN PUBLIC CHALLENGES
            
            if let publicChallenges = user.publicChallenges {
                for i in 0..<publicChallenges.count {
                    let challenge = publicChallenges[i]
                    
                    let snapshotPublic = try await FirebaseConstants.PublicChallengeCollection.document(challenge).collection("posts").whereField("ownerUid", isEqualTo: user.id).getDocuments()
                    
                    let publicPosts = snapshotPublic.documents.map {$0.documentID}
                    for i in 0..<publicPosts.count{
                        try await FirebaseConstants.PublicChallengeCollection.document(challenge).collection("posts").document(publicPosts[i]).delete()
                    }
                    
                }
            }
            
            //MARK: DELETE ALL POSTS USER HAS
            
           /* if let postIds = user.postIds {
                for i in 0..<postIds.count {
                    let postId = postIds[i]
                    if let postId = postId {
                        try await FirebaseConstants.PostCollection.do
                    }
                }
            }*/
            
           let snapshot = try await FirebaseConstants
                .PostCollection
                .whereField("ownerUid", isEqualTo: user.id)
                .getDocuments()
            
            let postCollectionIds = snapshot.documents.map {$0.documentID}
            
            for documentID in postCollectionIds {
                try await FirebaseConstants.PostCollection.document(documentID).delete()
            }
            
            
            //MARK: DELETE ALL STORYS USER HAS
            
            let Storysnapshot = try await FirebaseConstants
                .StoryCollection
                .whereField("ownerUid", isEqualTo: user.id)
                .getDocuments()
            
            let storyCollectionIds = snapshot.documents.map { $0.documentID}
            
            for documentId in storyCollectionIds {
                try await FirebaseConstants.StoryCollection.document(documentId).delete()
            }
            
            
            
            //MARK: DELETE ACCOUNT FROM FIREBASE...
            try await FirebaseConstants.UserCollection.document(user.id).delete()
            try await Auth.auth().currentUser?.delete()
        } catch {
            print("DEBUG APP ERROR: \(error.localizedDescription)")
        }
       
    }
    
    static func leaveCrew(_ user: User) async throws {
        do {
            let snapshot = try await FirebaseConstants
                .CrewCollection
                .whereField("uids", arrayContains: user.id)
                .getDocuments()
            
            var crews = snapshot.documents.compactMap({try? $0.data(as: Crew.self)})
            
            for i in 0..<crews.count {
                crews[i].uids.removeAll(where: {$0 == user.id})
                crews[i].userRating?.removeValue(forKey: user.id)
                
                try await FirebaseConstants.CrewCollection.document(crews[i].id).setData(from: crews[i], merge: false)
            }
            
           
        } catch {
            print("DEBUG APP ERROR FROM LEAVE \(error.localizedDescription)")
        }
    }
}

//MARK: - STREAKS
extension UserService {
    
  static func checkAndUpdateUserStreak(user: User) async throws -> Int?{
        
        let dateFormatter = DateFormatter()
      dateFormatter.locale = Locale(identifier: "en_US_POSIX")
      dateFormatter.dateFormat = "MMMddYY"
                var last7Days: [String] = []
        //MARK: THIS IS LAST 60 DAYS!!!
        for i in 0..<2 {
                    if let date = Calendar.current.date(byAdding: .day, value: -i, to: Date()) {
                        last7Days.append(dateFormatter.string(from: date))
                    }
                }
        
        print("DEBUG APP LAST 7 DAYS: \(last7Days)")
        
        do {
           let snapshot = try await FirebaseConstants.UserCollection.document(user.id).collection("story-days").document("batch1").getDocument()
            
            if let days = snapshot.data()?["storyDays"] as? [String]? {
                if (days ?? [] ).contains(last7Days[0]) || (days ?? [] ).contains(last7Days[1]){
                    print("DEBUG APP NOTHING TO UPDATE")
                    return nil
                } else {
                    print("DEBUG APP SHOULD UPDATE CURRENT STREAK TO 0")
                    try await FirebaseConstants.UserCollection.document(user.id).setData(["currentStreak": 0], merge: true)
                    return 0
                }
            }
            
        
            
            return nil
        } catch {
            return nil
        }
    }
}
