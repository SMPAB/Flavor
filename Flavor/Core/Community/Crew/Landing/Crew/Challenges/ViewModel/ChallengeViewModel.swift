//
//  ChallengeViewModel.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-21.
//

import Foundation
import Firebase
import SwiftUI

class ChallengeViewModel: ObservableObject {
    @Published var challenge: Challenge
    
    @Published var challengePosts: [ChallengeUpload] = []
    @Published var fetchingPosts = false
    private var latestPostSnapshot: DocumentSnapshot?
    
    @Published var selectedPost: String?
    @Published var selectedPostId = 1
    
    
    @Published var votes: [String] = []
    
    
    @Published var showVoteView = false
    
    
    @Published var votePost: ChallengeUpload?
    @Published var showVote = false
    
    
    //Edit
    
    @Published var image: Image?
    @Published var uiImage: UIImage?
    @Published var newName = ""
    @Published var newDescription = ""
    @Published var newStart = Date()
    @Published var newEnd = Date()
    
    
    init(challenge: Challenge) {
        self.challenge = challenge
        
        self.newName = challenge.title
        self.newDescription = challenge.description
        self.newStart = challenge.startDate.dateValue()
        self.newEnd = challenge.startDate.dateValue()
    }
    
    @MainActor
    func fetchPosts() async throws {
        do {
            fetchingPosts = true
            let (newPosts, latestDocument) = try await CrewService.fetchChallengePosts(challengeId: challenge.id, latestDocument: latestPostSnapshot)
            
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
    
    func vote(currentUser: User) async throws {
        do {
            if let post = votePost{
                votes.append(post.id)
                
                let _ = try await FirebaseConstants.ChallengeCollection.document(challenge.id).collection("posts").document(post.id).updateData(["votes": post.votes + 1])
                
                if let index = challengePosts.firstIndex(where: { $0.id == post.id }) {
                                // Update the votes count locally
                                challengePosts[index].votes += 1
                            }
                
                let _ = try await FirebaseConstants.ChallengeCollection.document(challenge.id).collection("votes").document(currentUser.id).setData([
                                "votes": FieldValue.arrayUnion([post.id])
                            ], merge: true)
            }
            
        } catch {
            return
        }
    }
    @MainActor
    func fetchVotes() async throws {
        self.votes = try await CrewService.fetchVotes(challenge)
        print("DEBUG APP VOTES: \(votes)")
    }
    
    func saveChanges() async throws {
        do {
            var data = [String:Any]()
            
            if newName != challenge.title {
                data["title"] = newName
                challenge.title = newName
            }
            
            if newDescription != challenge.description {
                data["description"] = newDescription
                challenge.description = newDescription
            }
            
            if newStart != challenge.startDate.dateValue() {
                data["startDate"] = Timestamp(date: newStart)
                challenge.startDate = Timestamp(date: newStart)
            }
            
            if newEnd != challenge.endDate.dateValue() {
                data["endDate"] = Timestamp(date: newEnd)
                challenge.endDate = Timestamp(date: newEnd)
            }
            
            if let uiImage = uiImage {
                let imageUrl = try await ImageUploader.uploadImage(image: uiImage)
                data["imageUrl"] = imageUrl
                challenge.imageUrl = imageUrl
            }
            
            if !data.isEmpty {
                try await FirebaseConstants.ChallengeCollection.document(challenge.id).updateData(data)
            }
        } catch {
            return
        }
    }
}
