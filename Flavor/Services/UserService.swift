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
                    let filteredUsernames = usernames.filter { usersToNotShow.contains($0) }
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
                let filteredUsernames = usernames.filter { usersToNotShow.contains($0) }
                        return filteredUsernames
                    } else {
                        return []
                    }
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
            let documentSnapshot = try await FirebaseConstants
                .userNameCollection
                .document("batch1")
                .getDocument()
            
            if let usernames = documentSnapshot.data()?["usernames"] as? [String] {
                // Assuming you need to filter usernames
                let filteredUsernames = usernames.filter { !usersToNotShow.contains($0) }
                return filteredUsernames
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
    static func fetchUserAlbums(_ userId: String, latestDocument: DocumentSnapshot? = nil) async throws -> ([Album], DocumentSnapshot?){
        do {
            var query: Query = FirebaseConstants
                .AlbumCollection
                .whereField("ownerUid", isEqualTo: userId)
                .limit(to: 10)
            
            
            if let lastDocument = latestDocument {
                query = query.start(afterDocument: lastDocument)
            }
            
            let snapshot = try await query.getDocuments()
            
           
            var albums = snapshot.documents.compactMap({ try? $0.data(as: Album.self)})
            
            let latestSnapshot = snapshot.documents.last
            
            return (albums, latestDocument)
        } catch {
            return ([], latestDocument)
        }
    }
}

