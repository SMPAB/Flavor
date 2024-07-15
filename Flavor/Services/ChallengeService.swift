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
                    .whereField("finished", isEqualTo: false)
                    .getDocuments()
                
                
                 var challenge = snapshot.documents.compactMap({try? $0.data(as: PublicChallenge.self)})
                
                for i in 0..<challenge.count {
                    let chall = challenge[i]
                   let completedsnapshot = try await FirebaseConstants.PublicChallengeCollection.document(chall.id).collection("completedUsers").document(user.id).getDocument()
                    
                    if completedsnapshot.exists {
                        challenge[i].userHasPublished = true
                    } else {
                        challenge[i].userHasPublished = false
                    }
                }
                    challenges.append(contentsOf: challenge)
                
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
    
    
    static func fetchAllPublicChallengs() async throws -> [PublicChallenge] {
        do {
            let snapshot = try await FirebaseConstants
                .PublicChallengeCollection
                .getDocuments()
            
            var challenges = snapshot.documents.compactMap({try? $0.data(as: PublicChallenge.self)})
            return challenges
        } catch {
            return []
        }
    }
    
    
    static func joinChallenge(challenge: PublicChallenge, currentUser: User) async throws {
        
        do {
            async let _ = try await FirebaseConstants
                .PublicChallengeCollection
                .document(challenge.id)
                .collection("usernames")
                .document("batch1")
                .setData(["usernames": FieldValue.arrayUnion([currentUser.userName])], merge: true)
            
            
            async let _ = try await FirebaseConstants
                .UserCollection
                .document(currentUser.id)
                .setData(["publicChallenges": FieldValue.arrayUnion([challenge.id])], merge: true)
                
        } catch {
            return
        }
    }
    
    static func leaveChallenge(challenge: PublicChallenge, currentUser: User) async throws {
        do {
            async let _ = try await FirebaseConstants
                .PublicChallengeCollection
                .document(challenge.id)
                .collection("usernames")
                .document("batch1")
                .setData(["usernames": FieldValue.arrayRemove([currentUser.userName])], merge: true)
            
            
            async let _ = try await FirebaseConstants
                .UserCollection
                .document(currentUser.id)
                .setData(["publicChallenges": FieldValue.arrayRemove([challenge.id])], merge: true)
            
            let postSnapshot = try await FirebaseConstants
                .PublicChallengeCollection
                .document(challenge.id)
                .collection("posts")
                .whereField("ownerUid", isEqualTo: currentUser.id)
                .getDocuments()
            
            let posts = postSnapshot.documents.compactMap({try? $0.data(as: ChallengeUpload.self)})
                
                if posts.count > 0 {
                    for i in 0..<posts.count {
                        let postId = posts[i].id
                        try await FirebaseConstants
                            .PublicChallengeCollection
                            .document(challenge.id)
                            .collection("posts")
                            .document(postId)
                            .delete()
                    }
                }
            
            try await FirebaseConstants
                .PublicChallengeCollection
                .document(challenge.id)
                .collection("completedUsers")
                .document(currentUser.id)
                .delete()
                
        } catch {
            return
        }
    }
    
    static func fetchChallengePosts(challengeId: String, latestDocument: DocumentSnapshot? = nil) async throws -> ([ChallengeUpload], DocumentSnapshot?) {
        do {
            var query: Query = FirebaseConstants
                .PublicChallengeCollection
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
    
    static func checkIfUserHasPublishedInChallenge(challengeId: String) async throws -> Bool {
        
        guard let uid = Auth.auth().currentUser?.uid else { return false}
        do {
          let snapshot =  try await FirebaseConstants.PublicChallengeCollection.document(challengeId).collection("completedUsers").document(uid).getDocument()
            
            return snapshot.exists
        } catch {
            return false
        }
    }
    
    
    static func checkIfUserHasVotedInChallenge(challenge: PublicChallenge) async throws -> Bool {
        guard let uid = Auth.auth().currentUser?.uid else { return false}
        
        do {
            let snapshot = try await FirebaseConstants.PublicChallengeCollection.document(challenge.id).collection("votes").document(uid).getDocument()
            
            if let data = snapshot.data(), let votes = data["votes"] as? [String], !votes.isEmpty {
                if votes.count == challenge.votes {
                    return true
                } else {
                    return false
                }
                   } else {
                       return false
                   }
        } catch {
            return false
        }
    }
    
    static func fetchUserPost(challengeId: String, homeVM: HomeViewModel) async throws -> ChallengeUpload?{
        guard let uid = Auth.auth().currentUser?.uid else { return nil}
        do {
            let snapshot = try await FirebaseConstants
                .PublicChallengeCollection
                .document(challengeId)
                .collection("posts")
                .whereField("ownerUid", isEqualTo: uid)
                .limit(to: 1)
                .getDocuments()
            
            var posts = snapshot.documents.compactMap({try? $0.data(as: ChallengeUpload.self)})
            
            for i in 0..<posts.count {
                posts[i].user = homeVM.user
            }
            
            return posts.first
        } catch {
            return nil
        }
    }
    
    
    
    static func fetchVotes(_ challenge: PublicChallenge) async throws -> [String]{
        guard let uid = Auth.auth().currentUser?.uid else { return []}
        
        do {
            let snapshot = try await FirebaseConstants
                .PublicChallengeCollection
                .document(challenge.id)
                .collection("votes")
                .document(uid)
                .getDocument()
            
            if let votes = snapshot.data()?["votes"] as? [String] {
                return votes
            } else {
                return []
            }
        } catch {
            return []
        }
    }
    
    static func fetchVotePosts(_ votes: [String], challenge: PublicChallenge) async throws -> [ChallengeUpload] {
        do {
            let snapshot = try await FirebaseConstants
                .PublicChallengeCollection
                .document(challenge.id)
                .collection("posts")
                .whereField("id", in: votes)
                .getDocuments()
            
            var posts = snapshot.documents.compactMap({try? $0.data(as: ChallengeUpload.self)})
            
            for i in 0..<posts.count {
                let post = posts[i]
                let ownerUid = post.ownerUid
                let user = try await UserService.fetchUser(withUid: ownerUid)
                posts[i].user = user
            }
            
            return posts
        } catch {
            return []
        }
    }
}
