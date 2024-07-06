//
//  LandingChallengeCellVM.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-07-05.
//

import Foundation

class LandingChallengeCellVM: ObservableObject {
    @Published var challenge: PublicChallenge
    
    init(challenge: PublicChallenge) {
        self.challenge = challenge
    }
    
    
    func checkIfUserHasPublished() async throws {
        
    }
    
    func checkIfUseHasVoted() async throws {
        
    }
}
