//
//  SearchCellViewModel.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-16.
//

import Foundation

class SearchCellViewModel: ObservableObject {
    @Published var username: String
    @Published var user: User?
    
    init(username: String) {
        self.username = username
    }
    
    func fetchUser() async throws {
        self.user = try await UserService.fetchUserWithUsername(withUsername: username)
    }
}
