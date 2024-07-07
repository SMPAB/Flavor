//
//  LandingPublicChallengesViewModel.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-07-05.
//

import Foundation

class LandingPublicChallengesViewModel: ObservableObject {
    
    @Published var searchText = ""
    
    @Published var userChallenges = [PublicChallenge]()
    
    @MainActor
    func fetchUserChallenges(user: User) async throws {
        self.userChallenges = try await ChallengeService.fetchUserChallenges(user: user)
    }
    
}
