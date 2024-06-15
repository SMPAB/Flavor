//
//  SubCommentCell.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-13.
//

import SwiftUI
import Iconoir
import Firebase

struct SubCommentCell: View {
    
    @StateObject var viewModel: SubCommentViewModel
    @EnvironmentObject var mainVM: CommentsViewModel
    @EnvironmentObject var primaryVM: PrimaryCommentCellViewModel
    
    init(subcomment: Comment){
        self._viewModel = StateObject(wrappedValue: SubCommentViewModel(subComment: subcomment))
    }
    
    private var comment: Comment {
        return viewModel.subComment
    }
    var body: some View {
        VStack(alignment: .leading){
            HStack(alignment: .top){
                ImageView(size: .xxsmall, imageUrl: comment.user?.profileImageUrl, background: false)
                
                VStack(alignment: .leading){
                    Text("\(comment.user?.userName ?? "") > \(comment.subCommentAnswerUsername ?? "")")
                        .font(.primaryFont(.P2))
                        .foregroundStyle(Color(.systemGray))
                    
                    Text(comment.commentText)
                        .font(.primaryFont(.P1))
                    
                }
            }
            
            HStack{
                Text(comment.timestamp.timestampString())
                    .font(.primaryFont(.P2))
                    .foregroundStyle(Color(.systemGray))
                
                Button(action: {
                    mainVM.replyComment = comment
                    mainVM.primaryCommentId = primaryVM.comment.id
                    mainVM.shouldFocusCommentField = true
                    mainVM.primaryComment = false
                }){
                    Text("Answer")
                        .font(.primaryFont(.P2))
                        .foregroundStyle(Color(.systemGray))
                        .fontWeight(.semibold)
                }
                
                Spacer()
                
                Button(action: {
                    handleLikedTapped()
                }){
                    if comment.isLiked == true{
                        Iconoir.heartSolid.asImage
                            .resizable()
                            .frame(width: 16, height: 16)
                            .foregroundStyle(Color(.systemRed))
                    } else {
                        Iconoir.heart.asImage
                            .resizable()
                            .frame(width: 16, height: 16)
                            .foregroundStyle(Color(.systemGray))
                    }
                }
            }
        }.background(.white)
        
        .contextMenu{
            
            if comment.ownerUid == Auth.auth().currentUser?.uid{
                Button(role: .destructive){
                    primaryVM.subComments.removeAll(where: {$0.id == comment.id})
                    Task{
                        try await viewModel.deleteComment(postId: mainVM.post.id, primaryCommentId: primaryVM.comment.id)
                    }
                } label: {
                    Label("Delete Comment", systemImage: "trash")
                        .font(.primaryFont(.P1))
                }
            } else {
                Button(role: .destructive){
                    Task{
                        try await viewModel.reportComment()
                    }
                } label: {
                    Label("Report Comment", systemImage: "exclamationmark.triangle")
                        .font(.primaryFont(.P1))
                }
            }
            
            
            Button(action: {
                
            }){
                Text("Cancel")
                    .font(.primaryFont(.P1))
            }
        }
        
        
        .onFirstAppear {
            Task{
               try await viewModel.checkIfUserHasLikedComment(postId: mainVM.post.id, primaryCommentId: primaryVM.comment.id)
            }
        }
    }
    
    func handleLikedTapped() {
        if comment.isLiked == true {
            Task{
                try await viewModel.unlike(postId: mainVM.post.id, primaryCommentId: primaryVM.comment.id)
            }
        } else {
            Task{
                try await viewModel.like(postId: mainVM.post.id, primaryCommentId: primaryVM.comment.id)
            }
        }
    }
}

