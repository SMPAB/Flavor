//
//  FriendRequestCellViewModel.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-17.
//

import Foundation

class FriendRequestCellViewModel: ObservableObject{
    private var userName: String
    @Published var user: User?

    private var homeVM: HomeViewModel
    init(userName: String, homeVM: HomeViewModel) {
        self.userName = userName
        self.homeVM = homeVM
    }
    
    func fetchUser() async throws {
        self.user = try await UserService.fetchUserWithUsername(withUsername: userName)
    }
    
    
    func accept() async throws {
        if let user = user {
            
            try await UserService.removeFriendRequest(userToRemoveFrom: homeVM.user, userRemoving: user)
            try await UserService.follow(userToFollow: homeVM.user, userFollowing: user)
            homeVM.friendRequestUsernames.removeAll(where: {$0 == userName})
            
        } else {
            return
        }
    }
    
    func remove() async throws{
        if let user = user {
            try await UserService.removeFriendRequest(userToRemoveFrom: homeVM.user, userRemoving: user)
            homeVM.friendRequestUsernames.removeAll(where: {$0 == userName})
        } else {
            return
        }
    }
}
