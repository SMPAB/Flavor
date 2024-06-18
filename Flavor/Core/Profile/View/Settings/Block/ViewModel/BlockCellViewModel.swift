//
//  BlockCellViewModel.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-17.
//

import Foundation

class BlockCellViewModel: ObservableObject {
    private let username: String
    @Published var user: User?
    
    init(username: String) {
        self.username = username
    }
    
    func fetchUser() async throws {
        self.user = try await UserService.fetchUserWithUsername(withUsername: username)
    }
    
    func unblock(currentUser: User) async throws {
        try await UserService.unblock(userToUnblock: user!, currentUser: currentUser)
    }
}
