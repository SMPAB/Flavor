//
//  NotificationService.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-17.
//

import Foundation
import Firebase

class NotificationService {
    
    @MainActor
    static func fetchNotifications(latestFetch: DocumentSnapshot? = nil) async throws -> ([Notification], DocumentSnapshot?){
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return ([], latestFetch)}
        
        do {
            
            var query: Query = FirebaseConstants
                .UserCollection
                .document(currentUid)
                .collection("notifications")
                .order(by: "timestamp", descending: true)
                .limit(to: 8)
            
            if let lastDocument = latestFetch {
                query = query.start(afterDocument: lastDocument)
            }
            
            
            let snapshot = try await query.getDocuments()
            
            
            var notifications = snapshot.documents.compactMap({ try? $0.data(as: Notification.self)})
            
            
            for i in 0..<notifications.count{
                var notification = notifications[i]
                //MARK: USERS
                var users: [User] = []
                for b in 0..<notification.userUids.count{
                    let user = try await UserService.fetchUser(withUid: notification.userUids[b])
                    users.append(user)
                }
                notifications[i].users = users
                //MARK: POST
                if let postId = notification.postId {
                    let post = try await PostService.fetchPost(postId)
                    notifications[i].post = post
                }
            }
            
            let lastDocument = snapshot.documents.last
            return (notifications, lastDocument)
            
        } catch {
            return ([], latestFetch)
        }
        
        
        
    }

    
    @MainActor
    func uploadNotification(toUid uid: String, type: NotificationsType, post: Post? = nil) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        var typeInt = 0
        
        if type == .like {
            typeInt = 0
        }
        if type == .comment {
            typeInt = 1
        }
        
        if type == .follow {
            typeInt = 2
        }
        do {
            //CHECK IF USER HAS A NOTIFICATION OF THIS TYPE
            
            
            let snapshot = try await FirebaseConstants
                .UserCollection
                .document(uid)
                .collection("notifications")
                .whereField("postId", isEqualTo: post?.id)
                .whereField("type", isEqualTo: typeInt)
                .getDocuments()
            
            if snapshot.isEmpty {
                //UPLOAD A NEW
                let ref = FirebaseConstants.UserCollection.document(uid).collection("notifications").document()
                
                /*let notification = Notification(id: ref.documentID,
                 timestamp: Timestamp(date: Date()),
                 type: type,
                 userUids: [currentUid],
                 read: false,
                 postId: post?.id
                 )*/
                
                let notification = Notification(id: ref.documentID,
                                                postId: post?.id,
                                                timestamp: Timestamp(date: Date()),
                                                type: type,
                                                userUids: [currentUid],
                                                read: false)
                
                guard let notificationData = try? Firestore.Encoder().encode(notification) else { return }
                try await ref.setData(notificationData)
            } else {
                //CHANGE THE OLD
                
                var notifications = snapshot.documents.compactMap({ try? $0.data(as: Notification.self)})
                if var primaryNotification = notifications.first {
                    // Update read status and append current user's ID if it's not already present
                    primaryNotification.read = false
                    if !primaryNotification.userUids.contains(currentUid) {
                        primaryNotification.userUids.append(currentUid)
                    }
                    primaryNotification.timestamp = Timestamp(date: Date())
                    
                    // Update the Firestore document with the new data
                    let ref = FirebaseConstants.UserCollection.document(uid).collection("notifications").document(primaryNotification.id)
                    guard let notificationData = try? Firestore.Encoder().encode(primaryNotification) else { return }
                    try await ref.setData(notificationData)
                }
                
                print("DEBUG APP OLD NOTIFICATION ==..")
            }
        } catch {
            print("DEBUG APP ERROR: \(error.localizedDescription)")
            return
        }
    }
    
    @MainActor
    static func fetchOneNotification() async throws -> Bool{
        guard let currentUid = Auth.auth().currentUser?.uid else { return false }
        
        do {
            let snapshot = try await FirebaseConstants
                .UserCollection
                .document(currentUid)
                .collection("notifications")
                .whereField("read", isEqualTo: false)
                .limit(to: 1)
                .getDocuments()
            
            if snapshot.count > 0 {
                return true
            } else {
                return false
            }
        } catch {
            return false
        }
    }
}

//MARK: PUSH NOTIFICATION
extension NotificationService {
    @MainActor
    func uploadCommentPush(toUid: String, post: Post) async throws {
        
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        do {
            
            let currentUser = try await UserService.fetchUser(withUid: currentUid)
            
            var data: [String:Any] = [
                "title": "commented on your post",
                "fromUsername": currentUser.userName,
                "imageUrl": post.imageUrls?[0] ?? ""
            ]
            
            try await FirebaseConstants.PushNotificationCollectio.document(toUid).collection("notifications").document().setData(data)
        } catch {
            return
        }
    }
    @MainActor
    func uploadLikePush(toUid: String, post: Post) async throws {
        
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        do {
            
            let currentUser = try await UserService.fetchUser(withUid: currentUid)
            
            var data: [String:Any] = [
                "title": "liked your post",
                "fromUsername": currentUser.userName,
                "imageUrl": post.imageUrls?[0] ?? ""
            ]
            
            try await FirebaseConstants.PushNotificationCollectio.document(toUid).collection("notifications").document().setData(data)
        } catch {
            return
        }
    }
    @MainActor
    func uploadFollow(toUid: String) async throws {
        
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        do {
            
            let currentUser = try await UserService.fetchUser(withUid: currentUid)
            
            let data: [String:Any] = [
                "title": "started following you",
                "fromUsername": currentUser.userName,
            ]
            
            try await FirebaseConstants.PushNotificationCollectio.document(toUid).collection("notifications").document().setData(data)
        } catch {
            return
        }
    }
    
    @MainActor
    func uploadCrewAnnouncment(crew: Crew, type: ForumType) async throws {
        
        do {
            var data: [String:Any] = [:]
            if type == .Announcement {
                data = [
                    "title": "has a new announcment",
                    "fromUsername": crew.crewName
                ]
            } else if type == .newChallenge {
                data = [
                    "title": "started added a new challenge",
                    "fromUsername": crew.crewName
                ]
            } else if type == .voting {
                data = [
                    "title": "started a new voting",
                    "fromUsername": crew.crewName
                ]
            } else {
                    data = [
                        "title": "has a new member!",
                        "fromUsername": crew.crewName
                    ]
                
            }
            
            for i in 0..<crew.uids.count {
                let userId = crew.uids[i]
                try await FirebaseConstants.PushNotificationCollectio.document(userId).collection("notifications").document().setData(data)
            }
        } catch {
            return
        }
    }
    
    
    @MainActor
    func uploadFriendRequest(toUid: String) async throws {
        
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        do {
            
            let currentUser = try await UserService.fetchUser(withUid: currentUid)
            
            var data: [String:Any] = [
                "title": "sent you a friend request",
                "fromUsername": currentUser.userName,
            ]
            
            try await FirebaseConstants.PushNotificationCollectio.document(toUid).collection("notifications").document().setData(data)
        } catch {
            return
        }
    }
    
}


