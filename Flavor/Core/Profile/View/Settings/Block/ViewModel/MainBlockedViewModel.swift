//
//  MainBlockedViewModel.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-17.
//

import Foundation

class MainBlockedViewModel: ObservableObject {
    @Published var blockedUsernames: [String] = []
    
    func fetchUsernames() async throws {
        self.blockedUsernames = try await UserService.fetchBlockedUsers()
    }
}
