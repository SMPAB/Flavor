import Foundation
import Firebase

class CommentService {
    
    @MainActor
    static func uploadPrimaryComment(_ comment: Comment, postId: String, documentId: String) async throws {
        guard let commentData = try? Firestore.Encoder().encode(comment) else { return }
        
        try await FirebaseConstants
            .PostCollection
            .document(postId)
            .collection("comments")
            .document(documentId)
            .setData(commentData)
    }
    
    @MainActor
    static func uploadSecondaryComment(_ comment: Comment, postId: String, primaryCommentId: String, documentId: String) async throws {
        guard let commentData = try? Firestore.Encoder().encode(comment) else { return }
        
        try await FirebaseConstants
            .PostCollection
            .document(postId)
            .collection("comments")
            .document(primaryCommentId)
            .collection("sub-comments")
            .document(documentId)
            .setData(commentData)
        
        
        let dataToMerge: [String: Any] = [
                "subCommentsIds": FieldValue.arrayUnion([documentId])
            ]
        
        try await FirebaseConstants
            .PostCollection
            .document(postId)
            .collection("comments")
            .document(primaryCommentId)
            .setData(dataToMerge, merge: true)
    }
    
    @MainActor
    static func fetchComments(_ postId: String, lastDocument: DocumentSnapshot? = nil) async throws -> ([Comment], DocumentSnapshot?) {
        
        print("DATAFETCHING: COMMENTS")
        var query: Query = FirebaseConstants
                    .PostCollection
                    .document(postId)
                    .collection("comments")
                    .order(by: "likes", descending: true)
                    .limit(to: 15)
        
                if let lastDocument = lastDocument {
                    query = query.start(afterDocument: lastDocument)
                }
        
       
        let snapshot = try await query.getDocuments()
            
        
        
        var comments = snapshot.documents.compactMap({ try? $0.data(as: Comment.self)})
        
        
        for i in 0 ..< comments.count {
            let comment = comments[i]
            let ownerUid = comment.ownerUid
            let commentUser = try await UserService.fetchUser(withUid: ownerUid)
            comments[i].user = commentUser
        }
        
       
        print("DATAFETCHING COMMENTS COUNT \(comments.count)")
        let lastSnapshot = snapshot.documents.last
                return (comments, lastSnapshot)
    }
    
    @MainActor
    static func fetchSecondaryComments(_ postID: String, primaryCommentId: String, lastDocument: DocumentSnapshot? = nil) async throws -> ([Comment], DocumentSnapshot?){
        var query: Query = FirebaseConstants
                    .PostCollection
                    .document(postID)
                    .collection("comments")
                    .document(primaryCommentId)
                    .collection("sub-comments")
                    .order(by: "likes", descending: true)
                    .limit(to: 3)
                
                if let lastDocument = lastDocument {
                    query = query.start(afterDocument: lastDocument)
                }
        
        let snapshot = try await query.getDocuments()
            
        
        var comments = snapshot.documents.compactMap({ try? $0.data(as: Comment.self)})
        
        for i in 0 ..< comments.count {
            let comment = comments[i]
            let ownerUid = comment.ownerUid
            let commentUser = try await UserService.fetchUser(withUid: ownerUid)
            comments[i].user = commentUser
        }
        
        print("DEBUG APP COMMENTS: \(comments)")
        let lastSnapshot = snapshot.documents.last
        
        return (comments, lastSnapshot)
    }
    
    @MainActor
    static func fetchTopComment(_ postId: String) async throws -> Comment?{
        
        do {
            let snapshot = try await FirebaseConstants
                .PostCollection
                .document(postId)
                .collection("comments")
                .order(by: "likes", descending: true)
                .limit(to: 1)
                .getDocuments()
            
            var comments = snapshot.documents.compactMap({ try? $0.data(as: Comment.self)})
            
            for i in 0 ..< comments.count {
                let comment = comments[i]
                let ownerUid = comment.ownerUid
                let commentUser = try await UserService.fetchUser(withUid: ownerUid)
                comments[i].user = commentUser
            }
            
            if comments.count > 0 {
                return comments[0]
            } else {
                return nil
            }
           
        } catch {
            return nil
        }
        
        
    }
}

//MARK: - LIKES
extension CommentService {
    
    //MARK: PRIMARY COMMENT
    @MainActor
    static func checkIfUserLikedPrimaryComment(postID: String, commentId: String) async throws -> Bool {
        
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return false }
        
        
        let snapshot = try await FirebaseConstants
            .PostCollection
            .document(postID)
            .collection("comments")
            .document(commentId)
            .collection("likes")
            .document(currentUid)
            .getDocument()
        
        
        return snapshot.exists
    }

    static func likeComment(postId: String, comment: Comment) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        async let _ = try await FirebaseConstants.PostCollection.document(postId).collection("comments").document(comment.id).collection("likes").document(uid).setData([:])
        async let _ = try await FirebaseConstants.PostCollection.document(postId).collection("comments").document(comment.id).updateData(["likes": comment.likes + 1])
    }
    static func unlikeComment(postId: String, comment: Comment) async throws {
        
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        async let _ = try await FirebaseConstants.PostCollection.document(postId).collection("comments").document(comment.id).collection("likes").document(uid).delete()
        async let _ = try await FirebaseConstants.PostCollection.document(postId).collection("comments").document(comment.id).updateData(["likes": comment.likes - 1])
        
        
    }
    
    //MARK: SECONDARY COMMENT
    @MainActor
    static func checkIfUserLikedSecondaryComment(postID: String, primaryCommentId: String, commentId: String) async throws -> Bool {
        
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return false }
        
        
        let snapshot = try await FirebaseConstants
            .PostCollection
            .document(postID)
            .collection("comments")
            .document(primaryCommentId)
            .collection("sub-comments")
            .document(commentId)
            .collection("likes")
            .document(currentUid)
            .getDocument()
        
        
        return snapshot.exists
    }

    static func likeSecondaryComment(postId: String, primaryCommentId: String, comment: Comment) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        async let _ = try await FirebaseConstants.PostCollection.document(postId).collection("comments").document(primaryCommentId).collection("sub-comments").document(comment.id).collection("likes").document(uid).setData([:])
        async let _ = try await FirebaseConstants.PostCollection.document(postId).collection("comments").document(primaryCommentId).collection("sub-comments").document(comment.id).updateData(["likes": comment.likes + 1])
    }
    static func unlikeSecondaryComment(postId: String, primaryCommentId: String, comment: Comment) async throws {
        
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        async let _ = try await FirebaseConstants.PostCollection.document(postId).collection("comments").document(primaryCommentId).collection("sub-comments").document(comment.id).collection("likes").document(uid).delete()
        async let _ = try await FirebaseConstants.PostCollection.document(postId).collection("comments").document(primaryCommentId).collection("sub-comments").document(comment.id).updateData(["likes": comment.likes - 1])
        
        
    }
}

//MARK: - DELETE
extension CommentService{
    static func deletePrimaryComment(_ postId: String, commentId: String) async throws {
        
        do {
            try await FirebaseConstants
                .PostCollection
                .document(postId)
                .collection("comments")
                .document(commentId)
                .delete()
        } catch {
            return
        }
        
    }
    
    static func deleteSecondaryComment(_ postId: String, primaryCommentId: String, commentId: String) async throws {
            do {
                // Delete the secondary comment document
                try await FirebaseConstants
                    .PostCollection
                    .document(postId)
                    .collection("comments")
                    .document(primaryCommentId)
                    .collection("sub-comments")
                    .document(commentId)
                    .delete()
                
                // Update the primary comment document to remove the commentId from subCommentsIds array
                let dataToUpdate: [String: Any] = [
                    "subCommentsIds": FieldValue.arrayRemove([commentId])
                ]
                
                try await FirebaseConstants
                    .PostCollection
                    .document(postId)
                    .collection("comments")
                    .document(primaryCommentId)
                    .updateData(dataToUpdate)
                
            } catch {
                return
            }
        }

}

