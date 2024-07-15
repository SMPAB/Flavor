//
//  RecomendedCellViewModel.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-07-14.
//

import Foundation

class RecomendedCellViewModel: ObservableObject {
    @Published var user: User
    
    init(user: User) {
        self.user = user
    }
    
    func follow(currentUser: User) async throws{
            self.user.isFollowed = true
            try await UserService.follow(userToFollow: user, userFollowing: currentUser)
        try await  NotificationsManager.shared.uploadFollowNotification(toUid: user.id)
    }
    
    func unfollow(currentUser: User) async throws {
        self.user.isFollowed = false
        try await UserService.unfollow(userToUnfollow: user, userUnfollowing: currentUser)
    }
}
