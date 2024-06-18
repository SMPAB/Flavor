//
//  NotificationsManager.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-17.
//

import Foundation

class NotificationsManager{
    
    static let shared = NotificationsManager()
    private let service = NotificationService()
    
    private init() { }
    func uploadLikeNotification(toUid uid: String, post: Post) async throws {
        
        try await service.uploadNotification(toUid: uid, type: .like, post: post)
    }
    
    func uploadCommentNotification(toUid uid: String, post: Post) async throws {
        try await service.uploadNotification(toUid: uid, type: .comment, post: post)
    }
    
    func uploadFollowNotification(toUid uid: String) async throws {
        try await service.uploadNotification(toUid: uid, type: .follow)
    }
}
