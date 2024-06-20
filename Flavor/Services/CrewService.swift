//
//  CrewService.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-19.
//

import Foundation
import Firebase
class CrewService {
    static func fetchUserCrews(latestSnapshot: DocumentSnapshot? = nil) async throws -> ([Crew], DocumentSnapshot?) {
        guard let uid = Auth.auth().currentUser?.uid else { return ([], latestSnapshot)}
        
        do {
            var query: Query = FirebaseConstants
                .CrewCollection
                .whereField("uids", arrayContains: uid)
                .limit(to: 20)
            
            if let latestSnapshot = latestSnapshot {
                query = query.start(afterDocument: latestSnapshot)
            }
            
            let snapshot = try await query.getDocuments()
            
            var crews = snapshot.documents.compactMap({ try? $0.data(as: Crew.self) })
            
            let lastSnapshot = snapshot.documents.last
            
            return (crews, latestSnapshot)
        } catch {
            return ([], latestSnapshot)
        }
    }
}

//MARK: - CHALLENGES

extension CrewService {
    static func fetchChallenges(crewId: String) async throws -> [Challenge] {
        
        do {
            let snapshot = try await FirebaseConstants
                .ChallengeCollection
                .whereField("crewId", isEqualTo: crewId)
                .getDocuments()
            
            var challenges = snapshot.documents.compactMap({try? $0.data(as: Challenge.self)})
            
            return challenges
        } catch {
            return []
        }
    }
}
