//
//  RegistrationViewModel.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-12.
//

import SwiftUI

class RegistrationViewModel: ObservableObject{

    
    @Published var email = ""
    @Published var userName = ""
    @Published var password = ""
    @Published var repeatPassword = ""
    
    @Published var allUserNames: [String] = []
    
    private let authService: AuthService
    
    init(authService: AuthService){
        self.authService = authService
    }
    
    func fetchAllUsernames() async throws {
        self.allUserNames = try await UserService.fetchAllUsernames()
    }
    
    func createUser() async throws {
        try await authService.createUserWithEmail(withEmail: email, password: password, birthday: nil, userName: userName, biography: nil, phoneNumber: nil, publicAccount: false, profileImage: nil)
    }
}


