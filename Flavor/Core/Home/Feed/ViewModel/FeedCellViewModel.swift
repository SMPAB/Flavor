//
//  FeedCellViewModel.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-13.
//

import Foundation

@MainActor
class FeedCellViewModel: ObservableObject {
    @Published var post: Post 
    @Published var topComment: Comment?
    
    @Published var showOptionsSheet = false
    @Published var showReportSheet = false
    init(post: Post) {
        self.post = post
    }
    
    
    func fetchTopComment() async throws {
        self.topComment = try await CommentService.fetchTopComment(post.id)
    }
    func checkIfuserHasSavedPost() async throws {
        do {
            self.post.hasSaved = try await PostService.checkIfUserSavedPost(post)
        } catch {
            return
        }
    }
    
    func checkIfUserHasLikedPost() async throws {
        do {
            self.post.hasLiked = try await PostService.checkIfUserLikedPost(post)
        } catch {
            return
        }
    }
    
    func like() async throws {
        do {
            let postCopy = post
            post.hasLiked = true
            post.likes += 1
            try await PostService.likePost(postCopy)
            try await NotificationsManager.shared.uploadLikeNotification(toUid: post.ownerUid, post: postCopy)
        } catch {
            return
        }
    }
    
    func unlike() async throws {
        do {
            let postCopy = post
            post.hasLiked = false
            post.likes -= 1
            try await PostService.unlikePost(postCopy)
        } catch {
            return
        }
    }
    
    func save() async throws {
        do {
            let postCopy = post
            post.hasSaved = true
            try await PostService.SavePost(postCopy)
        } catch {
            return
        }
    }
    
    func unsave() async throws {
        do {
            let postCopy = post
            post.hasSaved = false
            try await PostService.unSavePost(postCopy)
        } catch {
            return
        }
    }
    
    func pin(homeVM: HomeViewModel) async throws {
        do {
            let postCopy = post
            post.pinned = true
            
            if let pinnedPostid = homeVM.currentlyPinnedPost {
                
                if pinnedPostid != ""{
                    try await PostService.unpin(postId: pinnedPostid)
                }
               
            }
            
            try await PostService.pin(postId: postCopy.id)
            homeVM.currentlyPinnedPost = postCopy.id
        } catch {
            return
        }
    }
    
    func unpin() async throws {
        do {
            let postCopy = post
            post.pinned = false
            try await PostService.unpin(postId: postCopy.id)
        } catch {
            return
        }
    }
    
    func report(reportText: String) async throws {
        try await PostService.reportPost(reportText: reportText, post: post)
    }
}
