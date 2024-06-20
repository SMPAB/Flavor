//
//  CreateCrewUserCell.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-20.
//

import Foundation

class CreateCrewUserCell: ObservableObject {
    private var userName: String
    @Published var user: User?
    
    init(userName: String){
        self.userName = userName
    }
    
    func fetchUser() async throws {
        self.user = try await UserService.fetchUserWithUsername(withUsername: userName)
    }
}
