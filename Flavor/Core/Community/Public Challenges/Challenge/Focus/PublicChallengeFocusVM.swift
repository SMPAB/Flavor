//
//  PublicChallengeFocusVM.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-07-08.
//

import Foundation

class PublicChallengeFocusVM: ObservableObject {
    @Published var challenge: PublicChallenge
    @Published var showLeveChallengeAlert = false
    @Published var homeVM: HomeViewModel
    
    @Published var landingVM: LandingPublicChallengesViewModel
    
    
    init(challenge: PublicChallenge, homeVM: HomeViewModel, landingVM: LandingPublicChallengesViewModel) {
        self.challenge = challenge
        self.homeVM = homeVM
        self.landingVM = landingVM
        if (homeVM.user.publicChallenges ?? []).contains(challenge.id) {
            self.challenge.hasJoined = true
        } else {
            self.challenge.hasJoined = false
        }
        
    }
    
    
    func joinChallenge() async throws {
        do {
            self.challenge.hasJoined = true
            landingVM.otherChallenges.removeAll(where: {$0.id == challenge.id})
            landingVM.userChallenges.append(challenge)
            if homeVM.user.publicChallenges != nil {
                homeVM.user.publicChallenges?.append(challenge.id)
            } else {
                homeVM.user.publicChallenges = [challenge.id]
            }
            
            try await ChallengeService.joinChallenge(challenge: challenge, currentUser:  homeVM.user)
        } catch {
            return
        }
    }
    
    func leaveChallenge() async throws {
        do {
            self.challenge.hasJoined = false
            homeVM.user.publicChallenges?.removeAll(where: {$0 == challenge.id})
            try await ChallengeService.leaveChallenge(challenge: challenge, currentUser: homeVM.user)
        } catch {
            return
        }
    }
}
