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
        
        print("DEBUG APP PUBLIC CHALLENGES IDS: \(challengeIds)")
        do {
            for i in 0..<challengeIds!.count {
                print("DEBUG APP FOREACH PUBIC CHALLENGE")
                let challengeId = challengeIds![i]
                
                print("DEBUG APP BEFORE FETCHING FOR ID: \(challengeId)")
               let snapshot = try await FirebaseConstants
                    .PublicChallengeCollection
                    //.whereField("id", isEqualTo: challengeId)
                    //.whereField("finished", isEqualTo: false)
                    .getDocuments()
                
                print("DEBUG APP AFTER FETCHING")
                
                 let challenge = snapshot.documents.compactMap({try? $0.data(as: PublicChallenge.self)})
                    challenges.append(contentsOf: challenge)
                print("DEBUG APP CHALLENGE ID THAT IS APPENDING: \(challenge.map({$0.id}))")
                
            }
            
            return challenges
        } catch {
            print("DEBUG APP ERRORRRR: \(error.localizedDescription)")
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
