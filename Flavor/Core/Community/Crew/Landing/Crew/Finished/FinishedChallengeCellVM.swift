//
//  FinishedChallengeCellVM.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-07-06.
//

import Foundation

class FinishedChallengeCellVM: ObservableObject {
    @Published var challenge: Challenge
    
    @Published var winningPosts: [ChallengeUpload] = []
    
    init(challenge: Challenge) {
        self.challenge = challenge
    }
    
    func fetchWinningPosts() async throws {
        self.winningPosts = try await CrewService.fetchChallengeResultsPosts(challengeId: challenge.id)
    }
    
}
