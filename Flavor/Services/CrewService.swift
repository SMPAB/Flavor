//
//  CrewService.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-19.
//

import Foundation
import Firebase
class CrewService {
    
    static func fetchCrew(_ crewId: String) async throws -> Crew? {
        do {
            let snapshot = try await FirebaseConstants
                .CrewCollection
                .document(crewId)
                .getDocument()
            
            var crew = try snapshot.data(as: Crew.self)
            return crew
        } catch {
            return nil
        }
    }
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
    
    static func fetchUserChallenges() async throws -> [Challenge] {
        guard let currentUid = Auth.auth().currentUser?.uid else { return []}
        
        do {
            let snapshot = try await FirebaseConstants
                .ChallengeCollection
                .whereField("users", arrayContains: currentUid)
                .whereField("finished", isEqualTo: false)
                .getDocuments()
            
            var challenges = snapshot.documents.compactMap({ try? $0.data(as: Challenge.self)})
            
            for i in 0..<challenges.count {
                let crewId = challenges[i].crewId
                let crew = try await fetchCrew(crewId)
                challenges[i].crew = crew
            }
            
            return challenges
        } catch {
            return []
        }
    }
    
    static func fetchChallengePosts(challengeId: String, latestDocument: DocumentSnapshot? = nil) async throws -> ([ChallengeUpload], DocumentSnapshot?) {
        do {
            var query: Query = FirebaseConstants
                .ChallengeCollection
                .document(challengeId)
                .collection("posts")
                .order(by: "votes", descending: true)
                .limit(to: 8)
            
            if let latestDocument = latestDocument {
                query = query.start(afterDocument: latestDocument)
            }
            
            let snapshot = try await query.getDocuments()
            
            var posts = snapshot.documents.compactMap({try? $0.data(as: ChallengeUpload.self)})
            
            for i in 0..<posts.count {
                let post = posts[i]
                let ownerUid = post.ownerUid
                let user = try await UserService.fetchUser(withUid: ownerUid)
                posts[i].user = user
            }
            
            let latestCurrentDocument = snapshot.documents.last
            
            return (posts, latestCurrentDocument)
            
        } catch {
            return ([], latestDocument)
        }
    }
}
