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
    
    init() {
        Task{
            try await fetchUser()
        }
    }
    
    @MainActor
    func fetchUser() async throws{
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        self.user = try await UserService.fetchOptionalUser(withUid: currentUid)
        hasFetchedUser = true
    }
}
