//
//  PrimaryCommentCell.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-13.
//

import SwiftUI
import Firebase
import Iconoir

struct PrimaryCommentCell: View {
    
    @StateObject var viewModel: PrimaryCommentCellViewModel
    @EnvironmentObject var mainVM: CommentsViewModel
    
    init(comment: Comment, post: Post){
        self._viewModel = StateObject(wrappedValue: PrimaryCommentCellViewModel(comment: comment, post: post))
    }
    
    private var comment: Comment {
        return viewModel.comment
    }
    var body: some View {
        VStack(alignment: .leading){
            HStack(alignment: .top){
                ImageView(size: .xsmall, imageUrl: comment.user?.profileImageUrl, background: false)
                
                VStack(alignment: .leading){
                    Text(comment.user?.userName ?? "")
                        .font(.primaryFont(.P2))
                        .foregroundStyle(Color(.systemGray))
                    
                    Text(comment.commentText)
                        .font(.primaryFont(.P1))
                    
                    HStack{
                        Text(comment.timestamp.timestampString())
                            .font(.primaryFont(.P2))
                            .foregroundStyle(Color(.systemGray))
                        
                        Button(action: {
                            mainVM.replyComment = comment
                            mainVM.primaryCommentId = comment.id
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
                }
            }.background(.white)
            .contextMenu{
                
                if comment.ownerUid == Auth.auth().currentUser?.uid{
                    Button(role: .destructive){
                        mainVM.comments.removeAll(where: {$0.id == comment.id})
                        Task{
                            try await viewModel.deleteComment()
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
            LazyVStack{
                
                ForEach(mainVM.addedSubComments.filter({$0.primaryComment == comment.id})){ subComment in
                    SubCommentCell(subcomment: subComment)
                        .environmentObject(mainVM)
                        .environmentObject(viewModel)
                }
                ForEach(viewModel.subComments){ subComment in
                    SubCommentCell(subcomment: subComment)
                        .environmentObject(mainVM)
                        .environmentObject(viewModel)
                }
                
                if viewModel.fetchingSubComments{
                    Loading()
                }
                if comment.subCommentsIds.count > viewModel.subComments.count {
                    HStack{
                        Button(action: {
                            Task{
                                try await viewModel.fetchSubComments()
                                viewModel.fetchingSubComments = false
                            }
                        }){
                            Rectangle()
                                .fill(Color(.systemGray))
                                .frame(width: 20, height: 1)
                            
                            Text("Show \(comment.subCommentsIds.count - viewModel.subComments.count) answers")
                                .font(.primaryFont(.P2))
                                .foregroundStyle(Color(.systemGray))
                        }
                        
                        Spacer()
                    }
                    
                    
                }
            }.padding(.leading, 40)
           
            
            
        }.padding(.horizontal, 16)
            .onFirstAppear {
                Task{
                    try await viewModel.checkIfUserHasLikedComment(postId: mainVM.post.id)
                }
            }
    }
    
    func handleLikedTapped() {
        if comment.isLiked == true {
            Task{
                try await viewModel.unlike(postId: mainVM.post.id)
            }
        } else {
            Task{
                try await viewModel.like(postId: mainVM.post.id)
            }
        }
    }
}

#Preview {
    PrimaryCommentCell(comment: Comment(id: "", ownerUid: "", commentText: "", timestamp: Timestamp(date: Date()), likes: 1, subCommentsIds: [], subComment: false), post: Post.mockPosts[0])
}
