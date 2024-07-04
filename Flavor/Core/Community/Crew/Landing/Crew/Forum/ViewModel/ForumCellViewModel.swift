//
//  ForumCellViewModel.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-07-03.
//

import Foundation

class ForumCellViewModel: ObservableObject {
    @Published var forum: Forum
    
    init(forum: Forum) {
        self.forum = forum
    }
    
    
    func like (crewId: String) async throws {
        do {
            let postCopy = forum
            forum.isLiked = true
            forum.Upvotes! += 1
            
            if forum.isDisliked == true {
                try await unDisLike(crewId: crewId)
            }
            
            try await CrewService.upvoteForum(crewId: crewId, forumPost: postCopy)
        } catch {
            return
        }
    }
    
    func unlike (crewId: String) async throws {
        do {
            let postCopy = forum
            forum.isLiked = false
            forum.Upvotes! -= 1
            
            try await CrewService.unUpvoteForum(crewId: crewId, forumPost: postCopy)
        } catch {
            return
        }
    }
    
    func checkIfUserHasLiked(crewId: String) async throws {
        do {
            self.forum.isLiked = try await CrewService.checkIfUSerUpvoteForum(crewId: crewId, forumPost: forum)
        } catch {
            return
        }
    }
    
    func disLike (crewId: String) async throws {
        do {
            let postCopy = forum
            forum.isDisliked = true
            forum.DownVotes! += 1
            
            if forum.isLiked == true {
                try await unlike(crewId: crewId)
            }
            
            try await CrewService.downvoteForum(crewId: crewId, forumPost: postCopy)
        } catch {
            return
        }
    }
    
    func unDisLike (crewId: String) async throws {
        do {
            let postCopy = forum
            forum.isDisliked = false
            forum.DownVotes! -= 1
            
            try await CrewService.unDownvoteForum(crewId: crewId, forumPost: postCopy)
        } catch {
            return
        }
    }
    
    func checkIfUserHasDownVote(crewId: String) async throws {
        do {
            self.forum.isDisliked = try await CrewService.checkIfUSerDownvoteForum(crewId: crewId, forumPost: forum)
        } catch {
            return
        }
    }
}
