//
//  ChallengeViewModel.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-21.
//

import Foundation
import Firebase

class ChallengeViewModel: ObservableObject {
    @Published var challenge: Challenge
    
    @Published var challengePosts: [ChallengeUpload] = []
    @Published var fetchingPosts = false
    private var latestPostSnapshot: DocumentSnapshot?
    
    init(challenge: Challenge) {
        self.challenge = challenge
    }
    
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
}
