//
//  MainCommentsView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-13.
//

import SwiftUI

import SwiftUI
import Iconoir

struct MainCommentsView: View {
    
    
    @StateObject var viewModel: CommentsViewModel
    @EnvironmentObject var homeVM: HomeViewModel
    
    @FocusState private var isCommentFieldFocused: Bool
    
    init(post: Post){
        self._viewModel = StateObject(wrappedValue: CommentsViewModel(post: post))
    }
    var body: some View {
        VStack(spacing: 0){
            Text("Comments")
                .font(.custom("HankenGrotesk-Regular", size: .P1))
                .fontWeight(.semibold)
                .padding(.vertical)
            
            Divider()
            
            ScrollView{
                LazyVStack{
                    ForEach(viewModel.comments){ comment in
                        PrimaryCommentCell(comment: comment, post: viewModel.post)
                            .environmentObject(viewModel)
                            .onFirstAppear{
                                if comment.id == viewModel.comments.last?.id {
                                    Task{
                                      try await viewModel.fetchComments()
                                    }
                                   
                                }
                            }
                        
                        //Text("\(comment)")
                    }
                    
                    if viewModel.fetchingComments{
                        Loading()
                    }
                }.padding(.top)
            }
            
            Divider()
            
            HStack(spacing: 12){
               
                ImageView(size: .xsmall, imageUrl: homeVM.user.profileImageUrl, background: false)
                
                ZStack(alignment: .bottomTrailing){
                    
                    VStack{
                        if !viewModel.primaryComment {
                            HStack{
                                Text("Answering \(viewModel.replyComment?.user?.userName ?? "")")
                                    .font(.custom("HankenGrotesk-Regular", size: .P2))
                                    .foregroundStyle(Color(.systemGray))
                                
                                Button(action: {
                                    viewModel.replyComment = nil
                                    viewModel.primaryCommentId = nil
                                    viewModel.primaryComment = true
                                }){
                                    Iconoir.xmark.asImage
                                        .resizable()
                                        .frame(width: 12, height: 12)
                                        .foregroundStyle(Color(.systemGray))
                                }
                            }
                        }
                        
                        
                        TextField("Add a comment...", text: $viewModel.commentText, axis: .vertical)
                            .font(.custom("HankenGrotesk-Regular", size: .P2))
                            .padding(.trailing, 30)
                            .focused($isCommentFieldFocused)
                            
                    }.padding(8)
                    .overlay{
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    }
                    
                        
                    
                    if viewModel.commentText != ""{
                        Button(action: {
                            
                            if viewModel.primaryComment {
                                Task{
                                    try await viewModel.uploadPrimaryComment(commentText: viewModel.commentText, currentUser: homeVM.user)
                                }
                            } else {
                                Task{
                                    try await viewModel.uploadSecondaryComment(commentText: viewModel.commentText, currentUser: homeVM.user)
                                }
                            }
                            
                        }){
                            Iconoir.arrowUpCircleSolid.asImage
                                .foregroundStyle(Color(.colorOrange))
                                .padding(4)
                        }
                    }
                    
                    
                }
                
            }.padding()
        }.onFirstAppear {
            Task{
               try await viewModel.fetchComments()
            }
            
        }
        .onChange(of: viewModel.shouldFocusCommentField){ oldValue, newValue in
            print("DEBUG APP WORKING")
            print("DEBUG APP SHOULDFOCUSSATE \(viewModel.shouldFocusCommentField)")
            if viewModel.shouldFocusCommentField == true{
                isCommentFieldFocused = viewModel.shouldFocusCommentField
            }
        }
        .onChange(of: isCommentFieldFocused){ oldValue, newValue in
            viewModel.shouldFocusCommentField = isCommentFieldFocused
        }
        
    }
}

#Preview {
    MainCommentsView(post: Post.mockPosts[0])
        .environmentObject(HomeViewModel(user: User.mockUsers[0]))
}
