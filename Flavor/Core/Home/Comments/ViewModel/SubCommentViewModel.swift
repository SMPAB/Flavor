//
//  SubCommentViewModel.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-13.
//

import Foundation

class SubCommentViewModel: ObservableObject {
    @Published var subComment: Comment
    
    init(subComment: Comment) {
        self.subComment = subComment
    }
    
    
    func checkIfUserHasLikedComment(postId: String, primaryCommentId: String) async throws {
        self.subComment.isLiked = try await CommentService.checkIfUserLikedSecondaryComment(postID: postId, primaryCommentId: primaryCommentId, commentId: subComment.id)
    }
    
    func like(postId: String, primaryCommentId: String) async throws {
        do {
            let commentCopy = subComment
            subComment.likes += 1
            subComment.isLiked = true
            try await CommentService.likeSecondaryComment(postId: postId, primaryCommentId: primaryCommentId, comment: commentCopy)
        } catch {
            
        }
    }
    
    func unlike(postId: String, primaryCommentId: String) async throws {
        do {
            let commentCopy = subComment
            subComment.likes -= 1
            subComment.isLiked = false
            try await CommentService.unlikeSecondaryComment(postId: postId, primaryCommentId: primaryCommentId, comment: commentCopy)
        } catch {
            
        }
    }
    
    func deleteComment(postId: String, primaryCommentId: String) async throws {
        try await CommentService.deleteSecondaryComment(postId, primaryCommentId: primaryCommentId, commentId: subComment.id)
    }
    
    func reportComment() async throws {
        
    }
}
