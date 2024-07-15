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
    @Published var otherChallenges = [PublicChallenge]()
    
    @MainActor
    func fetchChallenges(user: User) async throws {
        
        var allChallenges = try await ChallengeService.fetchAllPublicChallengs()
        
        var userChallenges = allChallenges.filter({(user.publicChallenges ?? []).contains($0.id)})
        
        for i in 0..<userChallenges.count {
            userChallenges[i].userHasPublished = try await ChallengeService.checkIfUserHasPublishedInChallenge(challengeId: userChallenges[i].id)
            userChallenges[i].userDoneVoting = try await ChallengeService.checkIfUserHasVotedInChallenge(challenge: userChallenges[i])
        }
        self.userChallenges = userChallenges
        
        var otherChallenges = allChallenges.filter({!(user.publicChallenges ?? []).contains($0.id)})
        for i in 0..<otherChallenges.count {
            otherChallenges[i].userHasPublished = try await ChallengeService.checkIfUserHasPublishedInChallenge(challengeId: otherChallenges[i].id)
            otherChallenges[i].userDoneVoting = try await ChallengeService.checkIfUserHasVotedInChallenge(challenge: otherChallenges[i])
        }
        self.otherChallenges = otherChallenges
        
        self.otherChallenges.append(contentsOf: userChallenges) //MARK: REMOVE THIS
        
        //self.userChallenges = try await ChallengeService.fetchUserChallenges(user: user)
    }
    
    
}
