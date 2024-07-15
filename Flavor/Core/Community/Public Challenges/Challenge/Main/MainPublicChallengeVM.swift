//
//  MainPublicChallengeVM.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-07-10.
//

import Foundation
import Firebase

class MainPublicChallengeVM: ObservableObject {
    @Published var challenge: PublicChallenge
    
    @Published var userPost: ChallengeUpload?
    @Published var challengePosts: [ChallengeUpload] = []
    
    @Published var fetchingPosts = false
    @Published var latestPostSnapshot: DocumentSnapshot?
    
    @Published var votes: [String] = []
    @Published var voteUploads: [ChallengeUpload] = []
    
    @Published var landingVM: LandingPublicChallengesViewModel
    
    
    //VOTE
    @Published var showVoteView = false
    @Published var selectedPostId: Int = 0
    @Published var selectedPost: String?
    
    @Published var votePost: ChallengeUpload?
    @Published var showVote = false
    
    @Published var showUnvote = false
    @Published var unVotePost: ChallengeUpload?
    
    //DELTE
    @Published var deletePost: ChallengeUpload?
    @Published var showDeletePost = false
    init(challenge: PublicChallenge, landingVM: LandingPublicChallengesViewModel) {
        self.challenge = challenge
        self.landingVM = landingVM
    }
    
    @MainActor
    func fetchPosts() async throws {
        do {
            fetchingPosts = true
            let (newPosts, latestDocument) = try await ChallengeService.fetchChallengePosts(challengeId: challenge.id, latestDocument: latestPostSnapshot)
            
            for i in 0..<newPosts.count{
                if !challengePosts.contains(where: {$0.id == newPosts[i].id}){
                    challengePosts.append(newPosts[i])
                }
            }
            latestPostSnapshot = latestDocument
            fetchingPosts = false
        } catch {
            fetchingPosts = false
            return
        }
    }
    
    @MainActor
    func fetchUserPost(homeVM: HomeViewModel) async throws {
        do {
            self.userPost = try await ChallengeService.fetchUserPost(challengeId: challenge.id, homeVM: homeVM)
        } catch{
            return
        }
    }
    
    @MainActor
    func updateNewPost(post: ChallengeUpload, homeVM: HomeViewModel) {
         /*if let index = crewVM.challenges.firstIndex(where: {$0.id == challenge.id}) {
            crewVM.challenges[index].completedUsers.append(post.ownerUid)
        }
        
        challenge.completedUsers.append(post.ownerUid)*/
        
        homeVM.newUploadPublicChallenge.toggle()
        if let index = landingVM.userChallenges.firstIndex(where: {$0.id == challenge.id}) {
            landingVM.userChallenges[index].userHasPublished = true
        }
        
    
        userPost = post
        challengePosts.append(post)
       
    }
    
    
    @MainActor
    func deletePost(homeVM: HomeViewModel) async throws {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        do {
            if let post = deletePost {
                challengePosts.removeAll(where: {$0.id == post.id})
                challenge.userHasPublished = false
               // challenge.completedUsers.removeAll(where: {$0 == post.ownerUid})
                
                if let index = landingVM.userChallenges.firstIndex(where: {$0.id == challenge.id}){
                   // landingVM.userChallenges[index].completedUsers.removeAll(where: {$0 == post.ownerUid})
                    landingVM.userChallenges[index].userHasPublished = false
                }
                
                userPost = nil
                homeVM.newDeletePublicChallenge.toggle()
                
                try await FirebaseConstants.PublicChallengeCollection
                    .document(challenge.id)
                    .collection("posts")
                    .document(post.id)
                    .delete()
                
                try await FirebaseConstants.PublicChallengeCollection
                    .document(challenge.id)
                    .collection("completedUsers")
                    .document(currentUid)
                    .delete()
                
                
                
                if let voters = post.voters {
                    if voters.count > 0 {
                        for i in 0..<voters.count {
                            let voter = voters[i]
                            try await FirebaseConstants.PublicChallengeCollection.document(challenge.id).collection("votes").document(voter).setData(["votes": FieldValue.arrayRemove([post.id])], merge: true)
                        }
                    }
                }
                
                
                
            }
            
            
        } catch {
            return
        }
        
    }
    @MainActor
    func leaveChallenge(homeVM: HomeViewModel) async throws {
        self.challenge.hasJoined = false
        landingVM.userChallenges.removeAll(where: {$0.id == challenge.id})
        landingVM.otherChallenges.append(challenge)
        homeVM.user.publicChallenges?.removeAll(where: {$0 == challenge.id})
        try await ChallengeService.leaveChallenge(challenge: challenge, currentUser: homeVM.user)
    }
    
    func vote(currentUser: User, homeVM: HomeViewModel) async throws {
        do {
            if let post = votePost{
                votes.append(post.id)
                voteUploads.append(post)
                if votes.count == challenge.votes {
                    challenge.userDoneVoting = true
                }
                
                if let index = landingVM.userChallenges.firstIndex(where: {$0.id == challenge.id}){
                    landingVM.userChallenges[index].userDoneVoting = true
                }
                
                
                if let index = challengePosts.firstIndex(where: { $0.id == post.id }) {
                                // Update the votes count locally
                                challengePosts[index].votes += 1
                            }
                
                homeVM.newVotePublicChallenge.toggle()
                
                let _ = try await FirebaseConstants.PublicChallengeCollection.document(challenge.id).collection("posts").document(post.id).updateData(["votes": post.votes + 1])
                
               
                
                let _ = try await FirebaseConstants.PublicChallengeCollection.document(challenge.id).collection("votes").document(currentUser.id).setData([
                                "votes": FieldValue.arrayUnion([post.id])
                            ], merge: true)
                
                let _ = try await FirebaseConstants.PublicChallengeCollection.document(challenge.id).collection("posts").document(post.id).setData(["voters": FieldValue.arrayUnion([currentUser.id])], merge: true)
            }
            
        } catch {
            return
        }
    }
    
    func unVote(currentUser: User, homeVM: HomeViewModel) async throws {
        do {
            if let post = unVotePost {
                votes.removeAll(where: {$0 == post.id})
                voteUploads.removeAll(where: {$0.id == post.id})
                challenge.userDoneVoting = false
                
                if let index = landingVM.userChallenges.firstIndex(where: {$0.id == challenge.id}){
                    landingVM.userChallenges[index].userDoneVoting = false
                }
                
                
                
                if let index = challengePosts.firstIndex(where: {$0.id == post.id}){
                    challengePosts[index].votes -= 1
                }
                
                homeVM.newunVotePublicChallenge.toggle()
                
                let _ = try await FirebaseConstants.PublicChallengeCollection.document(challenge.id).collection("posts").document(post.id).updateData(["votes": post.votes - 1])
                
                
                
                
                
                let _ = try await FirebaseConstants.PublicChallengeCollection.document(challenge.id).collection("votes").document(currentUser.id).setData([
                                "votes": FieldValue.arrayRemove([post.id])
                            ], merge: true)
                
                let _ = try await FirebaseConstants.PublicChallengeCollection.document(challenge.id).collection("posts").document(post.id).setData(["voters": FieldValue.arrayRemove([currentUser.id])], merge: true)
            }
        } catch {
            return
        }
    }
    
    
    @MainActor
    func fetchVotes() async throws {
        self.votes = try await ChallengeService.fetchVotes(challenge)
        if !votes.isEmpty {
            self.voteUploads = try await ChallengeService.fetchVotePosts(votes, challenge: challenge)
        }
    }
}
