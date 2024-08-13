//
//  NotificationsManager.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-17.
//

import Foundation
import Firebase

class NotificationsManager{
    
    static let shared = NotificationsManager()
    private let service = NotificationService()
    
    private init() { }
    func uploadLikeNotification(toUid uid: String, post: Post) async throws {
        
        guard uid != Auth.auth().currentUser?.uid else { return }
        
        try await service.uploadNotification(toUid: uid, type: .like, post: post)
        try await service.uploadLikePush(toUid: uid, post: post)
    }
    
    func uploadCommentNotification(toUid uid: String, post: Post) async throws {
        guard uid != Auth.auth().currentUser?.uid else { return }
        
        try await service.uploadNotification(toUid: uid, type: .comment, post: post)
        try await service.uploadCommentPush(toUid: uid, post: post)
    }

    func uploadFollowNotification(toUid uid: String) async throws {
        
        guard uid != Auth.auth().currentUser?.uid else { return }
        
        try await service.uploadNotification(toUid: uid, type: .follow)
        try await service.uploadFollow(toUid: uid)
    }
    
    func uploadFriendRequestNotification(toUid uid: String) async throws {
        
        guard uid != Auth.auth().currentUser?.uid else { return }
        
        try await service.uploadFriendRequest(toUid: uid)
    }
    
    //MARK: CREW
    func uploadNewChallengeNotification(crew: Crew) async throws {
        try await service.uploadCrewAnnouncment(crew: crew, type: .newChallenge)
    }
    
    func uploadNewAnnouncmentNotification(crew: Crew) async throws {
        try await service.uploadCrewAnnouncment(crew: crew, type: .Announcement)
    }
    
    func uploadNewVotingNotification(crew: Crew) async throws {
        try await service.uploadCrewAnnouncment(crew: crew, type: .voting)
    }
}
