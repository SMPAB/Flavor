//
//  PrimaryCommentCellViewModel.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-13.
//

import Foundation
import Firebase

class PrimaryCommentCellViewModel: ObservableObject {
    @Published var comment: Comment
    private var post: Post
    
    @Published var subComments: [Comment] = []
    private var lastDocument: DocumentSnapshot?
    @Published var fetchingSubComments = false
    
    init(comment: Comment, post: Post) {
        self.comment = comment
        self.post = post
    }
    
    
    func fetchSubComments() async throws {
        fetchingSubComments = true
        let (fetchedComments, lastSnapshot) = try await CommentService.fetchSecondaryComments(post.id, primaryCommentId: comment.id, lastDocument: lastDocument)
        
        for fetchedComment in fetchedComments {
            if !self.subComments.contains(where: { $0.id == fetchedComment.id }) {
                self.subComments.append(fetchedComment)
            }
        }
        
        self.lastDocument = lastSnapshot
        fetchingSubComments = false
    }
    func checkIfUserHasLikedComment(postId: String) async throws {
        self.comment.isLiked = try await CommentService.checkIfUserLikedPrimaryComment(postID: postId, commentId: comment.id)
    }
    
    func like(postId: String) async throws {
        do {
            let commentCopy = comment
            comment.likes += 1
            comment.isLiked = true
            try await CommentService.likeComment(postId: postId, comment: commentCopy)
        } catch {
            
        }
    }
    
    func unlike(postId: String) async throws {
        do {
            let commentCopy = comment
            comment.likes -= 1
            comment.isLiked = false
            try await CommentService.unlikeComment(postId: postId, comment: commentCopy)
        } catch {
            
        }
    }
    
    func deleteComment() async throws {
        try await CommentService.deletePrimaryComment(post.id, commentId: comment.id)
    }
    
    func reportComment() async throws {
       
    }
}
