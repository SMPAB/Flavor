//
//  UserControllViewModel.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-12.
//

import Foundation
import Firebase

class UserControllViewModel: ObservableObject {
    @Published var user: User?
    @Published var hasFetchedUser = false
    
    @Published var allUsernames = [String]()
    
    init() {
        Task{
            try await fetchUser()
        }
    }
    
    @MainActor
    func fetchAllUsernames() async throws {
        self.allUsernames = try await UserService.fetchAllUsernames()
    }
    @MainActor
    func fetchUser() async throws{
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        self.user = try await UserService.fetchOptionalUser(withUid: currentUid)
        hasFetchedUser = true
    }
    
    @MainActor
    func createAccount(userName: String) async throws {
        let user = try await AuthService.shared.createAccount(username: userName)
        
        if let user = user {
            self.user = user
        }
    }
}
