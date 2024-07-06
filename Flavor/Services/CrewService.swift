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
    
    static func fetchChallengeWithId(_ id: String) async throws -> Challenge? {
        do {
            return try await FirebaseConstants.ChallengeCollection.document(id).getDocument().data(as: Challenge.self)
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
    static func fetchChallenges(crewId: String) async throws -> ([Challenge], newRating: [String: UserRating]?) {
        
        do {
            let snapshot = try await FirebaseConstants
                .ChallengeCollection
                .whereField("crewId", isEqualTo: crewId)
                .getDocuments()
            
            var challenges = snapshot.documents.compactMap({try? $0.data(as: Challenge.self)})
            
            var newRatings: [String: UserRating] = [:]
            
            for i in 0..<challenges.count {
                let challenge = challenges[i]
                
                //MARK: IF A CHALLENGE IS COMPLETED BUT NOT REGISTERED
                if challenge.endDate.dateValue() < Date() && challenge.finished != true{
                    try await FirebaseConstants.ChallengeCollection.document(challenge.id).updateData(["finished": true, "showFinishToUserIds": challenge.users])
                    challenges[i].finished = true
                    challenges[i].showFinishToUserIds = challenge.users
                    
                    let postSnapshot = try await FirebaseConstants
                        .ChallengeCollection
                        .document(challenge.id)
                        .collection("posts")
                        .order(by: "votes", descending: true)
                        .limit(to: 3)
                        .getDocuments()
                    
                    var posts = postSnapshot.documents.compactMap({try? $0.data(as: ChallengeUpload.self)})
                    var crew = try await CrewService.fetchCrew(challenge.crewId)
                    
                    
                    
                    if posts.count >= 1 {
                        print("DEBUG APP CREW: \(crewId) USER THAT SHOULD BE UPDATED AS FIRST PLACE: \(posts[0].ownerUid)")
                        if let crew = crew {
                            if let updatedRating = try await updatePointsForUserInCrew(crew: crew, userId: posts[0].ownerUid, points: 10, challengeId: challenge.id) {
                                                            newRatings[posts[0].ownerUid] = updatedRating
                                                        }
                        }
                        
                    }
                    if posts.count >= 2 {
                        print("DEBUG APP CREW: \(crewId) USER THAT SHOULD BE UPDATED SECOND PLACE: \(posts[1].ownerUid)")
                        if let crew = crew {
                            if let updatedRating = try await updatePointsForUserInCrew(crew: crew, userId: posts[1].ownerUid, points: 7, challengeId: nil) {
                                                            newRatings[posts[1].ownerUid] = updatedRating
                                                        }
                        }
                    }
                    if posts.count >= 3 {
                        print("DEBUG APP CREW: \(crewId) USER THAT SHOULD BE UPDATED AS THIRD: \(posts[2].ownerUid)")
                        if let crew = crew {
                            if let updatedRating = try await updatePointsForUserInCrew(crew: crew, userId: posts[2].ownerUid, points: 5, challengeId: nil) {
                                                            newRatings[posts[2].ownerUid] = updatedRating
                                                        }
                        }
                    }
                }
            }
            
            return (challenges, newRatings.isEmpty ? nil : newRatings)
        } catch {
            return ([], nil)
        }
    }
    
    static func updatePointsForUserInCrew(crew: Crew, userId: String, points: Int, challengeId: String?) async throws -> UserRating? {
            var updatedUserRating: UserRating?
            
            do {
                var crew = crew
                
                if var userRating = crew.userRating?[userId] {
                    userRating.points += points
                    if let challengeId = challengeId {
                        userRating.wins.append(challengeId)
                    }
                    crew.userRating?[userId] = userRating
                    
                    // Update only the userRating map in Firestore
                    try await FirebaseConstants.CrewCollection.document(crew.id).updateData([
                        "userRating.\(userId).points": userRating.points,
                        "userRating.\(userId).wins": userRating.wins
                    ])
                    
                    // Return the updated userRating
                    updatedUserRating = userRating
                } else {
                    // If userRating for userId doesn't exist, create a new entry
                    var newUserRating = UserRating(id: userId, points: points, wins: [], user: nil)
                    
                    if let challengeId = challengeId {
                        newUserRating.wins = [challengeId]
                    }
                    crew.userRating?[userId] = newUserRating
                    
                    // Update only the userRating map in Firestore
                    try await FirebaseConstants.CrewCollection.document(crew.id).updateData([
                        "userRating.\(userId)": newUserRating
                    ])
                    
                    // Return the updated userRating
                    updatedUserRating = newUserRating
                }
            } catch {
                print("Error updating user rating in crew: \(error.localizedDescription)")
            }
            
            return updatedUserRating
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
    
    
    static func fetchChallengeResultsPosts(challengeId: String) async throws -> [ChallengeUpload] {
        do {
            var query: Query = FirebaseConstants
                .ChallengeCollection
                .document(challengeId)
                .collection("posts")
                .order(by: "votes", descending: true)
                .limit(to: 3)
            
            
            let snapshot = try await query.getDocuments()
            
            var posts = snapshot.documents.compactMap({try? $0.data(as: ChallengeUpload.self)})
            
            for i in 0..<posts.count {
                let post = posts[i]
                let ownerUid = post.ownerUid
                let user = try await UserService.fetchUser(withUid: ownerUid)
                posts[i].user = user
            }
            
            let latestCurrentDocument = snapshot.documents.last
            
            return posts
            
        } catch {
            return ([])
        }
    }
    
    static func fetchVotes(_ challenge: Challenge) async throws -> [String]{
        guard let uid = Auth.auth().currentUser?.uid else { return []}
        
        do {
            let snapshot = try await FirebaseConstants
                .ChallengeCollection
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
    
    static func fetchVotePosts(_ votes: [String], challenge: Challenge) async throws -> [ChallengeUpload] {
        do {
            let snapshot = try await FirebaseConstants
                .ChallengeCollection
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

//MARK: - Forum

extension CrewService {
    static func fetchForum(crew: Crew, latestDocument: DocumentSnapshot? = nil) async throws -> ([Forum], DocumentSnapshot?) {
        do {
            var query: Query = FirebaseConstants
                .CrewCollection
                .document(crew.id)
                .collection("forum")
                .order(by: "timestamp", descending: true)
            
            if let latestDocument = latestDocument {
                query.start(afterDocument: latestDocument)
            }
            
            let snapshot = try await query.getDocuments()
            
            var forums = snapshot.documents.compactMap({try? $0.data(as: Forum.self)})
            
            for i in 0..<forums.count {
                let forum = forums[i]
                
                if let challengeId = forum.challengeID {
                    let challenge = try await fetchChallengeWithId(challengeId)
                    forums[i].challenge = challenge
                }
                
                if let newUserId = forum.newUserId {
                    let user = try await UserService.fetchUser(withUid: newUserId)
                    forums[i].user = user
                }
                
                if let UserId = forum.announcementTextOwnerId {
                    let user = try await UserService.fetchUser(withUid: UserId)
                    forums[i].user = user
                }
            }
            
            let latestDoc = snapshot.documents.last
            
            return (forums, latestDoc)
        } catch {
            return ([], latestDocument)
        }
    }
    
    
    static func upvoteForum(crewId: String, forumPost: Forum) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        do {
            async let _ = try await FirebaseConstants.CrewCollection.document(crewId).collection("forum").document(forumPost.id).collection("user-upvotes").document(currentUid) .setData([:])
            async let _ = try await FirebaseConstants.CrewCollection.document(crewId).collection("forum").document(forumPost.id).updateData(["Upvotes": (forumPost.Upvotes ?? 0) + 1])
        } catch {
            return
        }
        
        
    }
    
    static func unUpvoteForum(crewId: String, forumPost: Forum) async throws {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        do {
            async let _ = try await FirebaseConstants.CrewCollection.document(crewId).collection("forum").document(forumPost.id).collection("user-upvotes").document(currentUid).delete()
            async let _ = try await FirebaseConstants.CrewCollection.document(crewId).collection("forum").document(forumPost.id).updateData(["Upvotes": (forumPost.Upvotes ?? 0) - 1])
        } catch {
            return
        }
       
    }
     
    static func checkIfUSerUpvoteForum(crewId: String, forumPost: Forum) async throws -> Bool{
        guard let uid = Auth.auth().currentUser?.uid else { return false }
        
        do {
            let snapshot = try await FirebaseConstants
                .CrewCollection
                .document(crewId)
                .collection("forum")
                .document(forumPost.id)
                .collection("user-upvotes")
                .document(uid)
                .getDocument()
            
            return snapshot.exists
        } catch {
            return false
        }
    }
    
    static func downvoteForum(crewId: String, forumPost: Forum) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        do {
            async let _ = try await FirebaseConstants.CrewCollection.document(crewId).collection("forum").document(forumPost.id).collection("user-downvotes").document(currentUid) .setData([:])
            async let _ = try await FirebaseConstants.CrewCollection.document(crewId).collection("forum").document(forumPost.id).updateData(["DownVotes": (forumPost.DownVotes ?? 0) + 1])
        } catch {
            return
        }
        
        
    }
    
    static func unDownvoteForum(crewId: String, forumPost: Forum) async throws {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        do {
            async let _ = try await FirebaseConstants.CrewCollection.document(crewId).collection("forum").document(forumPost.id).collection("user-downvotes").document(currentUid).delete()
            async let _ = try await FirebaseConstants.CrewCollection.document(crewId).collection("forum").document(forumPost.id).updateData(["DownVotes": (forumPost.DownVotes ?? 0) - 1])
        } catch {
            return
        }
       
    }
    
    static func checkIfUSerDownvoteForum(crewId: String, forumPost: Forum) async throws -> Bool{
        guard let uid = Auth.auth().currentUser?.uid else { return false }
        
        do {
            let snapshot = try await FirebaseConstants
                .CrewCollection
                .document(crewId)
                .collection("forum")
                .document(forumPost.id)
                .collection("user-downvotes")
                .document(uid)
                .getDocument()
            
            return snapshot.exists
        } catch {
            return false
        }
    }
}
