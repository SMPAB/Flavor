//
//  ListCellViewModel.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-12.
//

import Foundation

class ListCellViewModel: ObservableObject {
    private var username: String
    @Published var user: User?
    
    init(username: String) {
        self.username = username
    }
    
    func fetchUser() async throws {
        self.user = try await UserService.fetchUserWithUsername(withUsername: username)
        
        if let user = user{
            try await checkIfUserIsFollowing(id: user.id)
            try await checkIfUserHasfriendRequest(id: user.id)
        }
        
    }
    
    private func checkIfUserIsFollowing(id: String) async throws {
        self.user?.isFollowed = try await UserService.checkIfUserIsFollowing(id)
    }
    
    private func checkIfUserHasfriendRequest(id: String) async throws {
        self.user?.hasFriendRequests = try await UserService.checkIfUserHasFriendRequest(id)
    }
    
    func follow(userToFollow: User, userFollowing: User) async throws{
            self.user?.isFollowed = true
            try await UserService.follow(userToFollow: userToFollow, userFollowing: userFollowing)
        try await  NotificationsManager.shared.uploadFollowNotification(toUid: userToFollow.id)
    }
    
    func unfollow(userToUnfollow: User, userUnfollowing: User) async throws {
        self.user?.isFollowed = false
        try await UserService.unfollow(userToUnfollow: userToUnfollow, userUnfollowing: userUnfollowing)
    }
    
    func unsendFriendRequest(userToUnFriendRequest: User, userUnfriendrequesting: User) async throws{
        self.user?.hasFriendRequests = false
        try await UserService.removeFriendRequest(userToRemoveFrom: userToUnFriendRequest, userRemoving: userUnfriendrequesting)
    }
    
    func sendFriendRequest(sendRequestTo: User, userSending: User) async throws{
        self.user?.hasFriendRequests = true
        try await UserService.sendFriendRequest(userToSendFriendRequestTo: sendRequestTo, userSending: userSending)
        try await NotificationsManager.shared.uploadFriendRequestNotification(toUid: sendRequestTo.id)
    }
}
