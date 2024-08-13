//
//  CommentsViewModel.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-13.
//

import Foundation
import Firebase

class CommentsViewModel: ObservableObject {
    
    @Published var primaryComment = true
    @Published var shouldFocusCommentField: Bool = false
    
    @Published var post: Post
    @Published var comments: [Comment] = []
    
    @Published var commentText = ""
    
    private var lastDocument: DocumentSnapshot?
    
    //SUB KOMMENTING
    @Published var replyComment: Comment?
    @Published var primaryCommentId: String?
    
    @Published var addedSubComments: [Comment] = []
    
    @Published var fetchingComments = false
    @Published var initialFetchedCompleted = false
    
    @Published var cellVM: FeedCellViewModel
    
    init(post: Post, cellVM: FeedCellViewModel) {
        self.post = post
        self.cellVM = cellVM
    }
    
    @MainActor
    func uploadPrimaryComment(commentText: String, currentUser: User) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let docId = FirebaseConstants.PostCollection.document(post.id).collection("comments").document().documentID
        
        let comment = Comment(id: docId,
                              ownerUid: uid,
                              commentText: commentText,
                              timestamp: Timestamp(date: Date()),
                              likes: 0,
                              subCommentsIds: [],
                              subComment: false
        )
        
        let commentToDisplay = Comment(id: docId,
                                       ownerUid: uid,
                                       commentText: commentText,
                                       timestamp: Timestamp(date: Date()),
                                       likes: 0,
                                       subCommentsIds: [],
                                       subComment: false,
                                       user: currentUser
        )
        
        //comments.append(commentToDisplay)
        
        if comments.isEmpty {
            cellVM.topComment = commentToDisplay
        }
        
        comments.insert(commentToDisplay, at: 0)
        self.commentText = ""
        try await CommentService.uploadPrimaryComment(comment, postId: post.id, documentId: docId)
        try await NotificationsManager.shared.uploadCommentNotification(toUid: post.ownerUid, post: post)
        
    
    }
    
    @MainActor
    func uploadSecondaryComment(commentText: String, currentUser: User) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let docId = FirebaseConstants.PostCollection.document(post.id).collection("comments").document(primaryCommentId!).collection("sub-comments").document().documentID
        
        let comment = Comment(id: docId,
                              ownerUid: uid,
                              commentText: commentText,
                              timestamp: Timestamp(date: Date()),
                              likes: 0,
                              subCommentsIds: [],
                              subComment: true,
                              primaryComment: primaryCommentId!,
                              subCommentAnswerUsername: replyComment?.user?.userName ?? "",
                              subCommentAnswerCommentId: replyComment?.id
        )
        
        let commentToDisplay = Comment(id: docId,
                                       ownerUid: uid,
                                       commentText: commentText,
                                       timestamp: Timestamp(date: Date()),
                                       likes: 0,
                                       subCommentsIds: [],
                                       subComment: true,
                                       primaryComment: primaryCommentId!,
                                       subCommentAnswerUsername: replyComment?.user?.userName ?? "",
                                       subCommentAnswerCommentId: replyComment?.id,
                                       user: currentUser
        )
        
        addedSubComments.insert(commentToDisplay, at: 0)
        self.commentText = ""
        try await CommentService.uploadSecondaryComment(comment, postId: post.id, primaryCommentId: primaryCommentId!, documentId: docId)
    }
    
    @MainActor
    func fetchComments() async throws {
        fetchingComments = true
        let (fetchedComments, lastSnapshot) = try await CommentService.fetchComments(post.id, lastDocument: lastDocument)
        self.comments.append(contentsOf: fetchedComments)
        self.lastDocument = lastSnapshot
        fetchingComments = false
        initialFetchedCompleted = true
    }
}

