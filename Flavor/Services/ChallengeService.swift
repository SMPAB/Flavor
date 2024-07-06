//
//  ChallengeService.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-07-05.
//

import Foundation
import Firebase

class ChallengeService {
    
    static func fetchUserChallenges(user: User) async throws -> [PublicChallenge] {
        
        var challenges: [PublicChallenge] = []
        
        let challengeIds = user.publicChallenges
        guard challengeIds != nil && challengeIds != [] else { return []}
        do {
            for i in 0..<challengeIds!.count {
                let challengeId = challengeIds![i]
               let snapshot = try await FirebaseConstants
                    .PublicChallengeCollection
                    .whereField("id", isEqualTo: challengeId)
                    .getDocuments()
                
                 let challenge = snapshot.documents.compactMap({try? $0.data(as: PublicChallenge.self)})
                    challenges.append(contentsOf: challenge)
                
                
            }
            
            return challenges
        } catch {
            return []
        }
    }
    
    
    static func fetchPublicChallenge(challengeId: String) async throws -> PublicChallenge? {
        do {
            return try await FirebaseConstants
                .PublicChallengeCollection
                .document(challengeId)
                .getDocument()
                .data(as: PublicChallenge.self)
        } catch {
            return nil
        }
    }
    
}
