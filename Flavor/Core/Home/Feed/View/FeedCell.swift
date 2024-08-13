//
//  FeedCell.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-13.
//

import SwiftUI
import Kingfisher
import Iconoir

struct FeedCell: View {
    @StateObject var viewModel: FeedCellViewModel
    @EnvironmentObject var homeVM: HomeViewModel
    
    @State var showComments = false
    @State var hapticPuls = false
    
    init(post: Post){
        self._viewModel = StateObject(wrappedValue: FeedCellViewModel(post: post))
    }
    
    
    var post: Post{
        return viewModel.post
    }
    
    var hasLiked: Bool{
        return viewModel.post.hasLiked ?? false
    }
    
    var hasSaved: Bool {
        return viewModel.post.hasSaved ?? false
    }
    var body: some View {
        
        let width = UIScreen.main.bounds.width
        VStack(spacing: 8){
            if let user = post.user {
                if user.isCurrentUser {
                    HStack(spacing: 16){
                        ImageView(size: .small, imageUrl: user.profileImageUrl, background: false)
                        
                        VStack(alignment: .leading){
                            Text(user.userName)
                                .font(.primaryFont(.P1))
                                .fontWeight(.semibold)
                            
                            Text(post.timestamp.timestampString())
                                .font(.primaryFont(.P2))
                                
                        }
                        
                        Spacer()
                        
                       
                            Button(action: {
                                viewModel.showOptionsSheet.toggle()
                            }){
                                Iconoir.moreHoriz.asImage
                                    .foregroundStyle(.black)
                            }
                        
                        
                    }.foregroundStyle(.black)
                } else {
                    NavigationLink(destination:
                                    ProfileView(user: user)
                        .environmentObject(homeVM)
                    
                    ){
                        HStack(spacing: 16){
                            ImageView(size: .small, imageUrl: user.profileImageUrl, background: false)
                            
                            VStack(alignment: .leading){
                                Text(user.userName)
                                    .font(.primaryFont(.P1))
                                    .fontWeight(.semibold)
                                
                                Text(post.timestamp.timestampString())
                                    .font(.primaryFont(.P2))
                                    
                            }
                            
                            Spacer()
                            
                           
                                Button(action: {
                                    viewModel.showOptionsSheet.toggle()
                                }){
                                    Iconoir.moreHoriz.asImage
                                        .foregroundStyle(.black)
                                }
                            
                            
                        }.foregroundStyle(.black)
                    }
                }
            }
            VStack(spacing: 0){
                if post.title != nil && post.title != ""{
                    Text(post.title ?? "")
                        .font(.primaryFont(.P1))
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                if post.caption != nil && post.caption != ""{
                    Text(post.caption ?? "")
                        .font(.primaryFont(.P2))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                }
            }
            
            if post.imageUrls?.count == 1 {
                KFImage(URL(string: post.imageUrls![0]))
                    .resizable()
                    .scaledToFill()
                    .frame(height: 250)
                    .frame(width: width - 32 - 16)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .contentShape(RoundedRectangle(cornerRadius: 16))
                    .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemGray))
                    )
                    .onTapGesture{
                        homeVM.focusPost = post
                        homeVM.focusPostIndex = 0
                        homeVM.showFocusPost.toggle()
                    }
            } else if post.imageUrls?.count == 2 {
                HStack(spacing: 8){
                    KFImage(URL(string: post.imageUrls![0]))
                        .resizable()
                        .scaledToFill()
                        .frame(height: 250)
                        .frame(width: width - 32 - 120 - 16)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .contentShape(RoundedRectangle(cornerRadius: 16))
                        .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemGray))
                        )
                        .onTapGesture{
                            homeVM.focusPost = post
                            homeVM.focusPostIndex = 0
                            homeVM.showFocusPost.toggle()
                        }
                    
                    KFImage(URL(string: post.imageUrls![1]))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120 - 8,height: 250)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .contentShape(RoundedRectangle(cornerRadius: 16))
                        .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemGray))
                        )
                        .onTapGesture{
                            homeVM.focusPost = post
                            homeVM.focusPostIndex = 1
                            homeVM.showFocusPost.toggle()
                        }
                }
            } else if post.imageUrls?.count == 3 {
                HStack(spacing: 8){
                    KFImage(URL(string: post.imageUrls![0]))
                        .resizable()
                        .scaledToFill()
                        .frame(height: 250)
                        .frame(width: width - 32 - 120 - 16)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .contentShape(RoundedRectangle(cornerRadius: 16))
                        .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemGray))
                        )
                        .onTapGesture{
                            homeVM.focusPost = post
                            homeVM.focusPostIndex = 0
                            homeVM.showFocusPost.toggle()
                        }
                    
                    VStack(spacing: 8){
                        KFImage(URL(string: post.imageUrls![1]))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 125-4)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .contentShape(RoundedRectangle(cornerRadius: 16))
                            .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.systemGray))
                            )
                            .onTapGesture{
                                homeVM.focusPost = post
                                homeVM.focusPostIndex = 1
                                homeVM.showFocusPost.toggle()
                            }
                        
                        KFImage(URL(string: post.imageUrls![2]))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 125-4)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .contentShape(RoundedRectangle(cornerRadius: 16))
                            .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.systemGray))
                            )
                            .onTapGesture{
                                homeVM.focusPost = post
                                homeVM.focusPostIndex = 2
                                homeVM.showFocusPost.toggle()
                            }
                    }.frame(height: 250)
                    
                }
            } else if post.imageUrls?.count ?? 0 > 3 {
                HStack(spacing: 8){
                    KFImage(URL(string: post.imageUrls![0]))
                        .resizable()
                        .scaledToFill()
                        .frame(height: 250)
                        .frame(width: width - 32 - 120 - 16)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .contentShape(RoundedRectangle(cornerRadius: 16))
                        .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemGray))
                        )
                        .onTapGesture{
                            homeVM.focusPost = post
                            homeVM.focusPostIndex = 0
                            homeVM.showFocusPost.toggle()
                        }
                    
                    VStack(spacing: 8){
                        KFImage(URL(string: post.imageUrls![1]))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 125-4)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .contentShape(RoundedRectangle(cornerRadius: 16))
                            .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.systemGray))
                            )
                            .onTapGesture{
                                homeVM.focusPost = post
                                homeVM.focusPostIndex = 1
                                homeVM.showFocusPost.toggle()
                            }
                        
                        ZStack{
                            KFImage(URL(string: post.imageUrls![2]))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 125-4)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .contentShape(RoundedRectangle(cornerRadius: 16))
                                .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(.systemGray))
                                ).overlay{
                                    ZStack{
                                        Color.black.opacity(0.5)
                                            .cornerRadius(16)
                                        
                                        Text("+\(post.imageUrls?.count ?? 4 - 3)")
                                            .font(.primaryFont(.H3))
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.colorWhite)
                                    }
                                    
                                }
                                .onTapGesture{
                                    homeVM.focusPost = post
                                    homeVM.focusPostIndex = 2
                                    homeVM.showFocusPost.toggle()
                                }
                        }.frame(width: 120, height: 125-4)
                        
                    }.frame(height: 250)
                    
                    
                    
                    
                }
            }
            
            
            HStack{
                Button(action: {
                    handleLikedTapped()
                }){
                    if hasLiked{
                        Iconoir.heartSolid.asImage
                            .foregroundStyle(Color(.systemRed))
                    } else {
                        Iconoir.heart.asImage
                            .foregroundStyle(.black)
                    }
                }
                
                Text("\(post.likes) Likes")
                    .font(.primaryFont(.P1))
                
                Spacer()
                
                if viewModel.topComment == nil {
                    Button(action: {
                        showComments.toggle()
                    }) {
                        Iconoir.chatBubbleEmpty.asImage
                            .foregroundStyle(.black)
                    }
                }
                
                if let recipeId = post.recipeId {
                    NavigationLink(destination:
                    MainRecipeView(recipeId: recipeId)
                        .navigationBarBackButtonHidden(true)
                    ){
                        Iconoir.pageStar.asImage
                            .foregroundStyle(.black)
                    }
                }
                
                Button(action: {
                    handleSavedTapped()
                }){
                    if hasSaved {
                        Iconoir.bookmarkSolid.asImage
                            .foregroundStyle(.colorOrange)
                    } else {
                        Iconoir.bookmark.asImage
                            .foregroundStyle(.colorOrange)
                    }
                }
                
                
            }
            
            
            
            if let comment = viewModel.topComment{
                
                HStack(spacing: 4){
                    Iconoir.chatBubbleEmpty.asImage
                        .resizable()
                        .frame(width: 12, height: 12)
                        .foregroundStyle(Color(.systemGray))
                    
                    Text("Comments")
                        .font(.primaryFont(.P2))
                        .foregroundStyle(Color(.systemGray))
                    
                    Spacer()
                }.onTapGesture {
                    showComments.toggle()
                }
                
                HStack(alignment: .top){
                    ImageView(size: .xxsmall, imageUrl: comment.user?.profileImageUrl, background: false)
                    
                    Text(comment.commentText)
                        .font(.primaryFont(.P2))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        //.frame(minHeight: 30, alignment: .top)
                        .padding(8)
                        .background(
                            Bubble(isFromCurrentUser: false)
                                .fill(Color(.systemGray6))
                        )
                }.padding(.horizontal, 16)
                .onTapGesture {
                    showComments.toggle()
                }
            }
            
           
        }.padding(8)
            .onChange(of: homeVM.newEditPost){
                if let post = homeVM.newEditPost {
                    if viewModel.post.id == post.id {
                        viewModel.post = post
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                            homeVM.newEditPost = nil
                        }
                    }
                }
            }
            .sensoryFeedback(.impact(weight: .heavy, intensity: 1), trigger: hapticPuls)
            
        .onFirstAppear {
            Task{
                try await viewModel.checkIfuserHasSavedPost()
            }
            Task{
                try await viewModel.checkIfUserHasLikedPost()
            }
            
            Task{
                try await viewModel.fetchTopComment()
            }
        }
        .sheet(isPresented: $showComments){
            MainCommentsView(post: post, cellVM: viewModel)
                .environmentObject(homeVM)
        }
        .sheet(isPresented: $viewModel.showOptionsSheet, content: {
            OptionsSheet()
                .padding(.top, 16)
                .environmentObject(viewModel)
                .environmentObject(homeVM)
                .presentationDragIndicator(.visible)
                .presentationDetents([homeVM.user.id == post.user?.id ? .height(250) : .height(200)])
        })
        .fullScreenCover(isPresented: $viewModel.showReportSheet, content: {
            ReportPostView()
                .environmentObject(viewModel)
        })
    }
    
    func handleLikedTapped() {
        if hasLiked {
            Task{
                try await viewModel.unlike()
            }
        } else {
            Task{
                hapticPuls.toggle()
               try await viewModel.like()
            }
        }
    }
    
    func handleSavedTapped() {
        if hasSaved{
            Task{
                try await viewModel.unsave()
            }
        } else {
            Task{
                hapticPuls.toggle()
                try await viewModel.save()
            }
        }
    }
}

struct Bubble: Shape {
    
    var isFromCurrentUser: Bool
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [isFromCurrentUser ? .topLeft : .topRight, .bottomLeft, .bottomRight], cornerRadii: CGSize(width: 16, height: 16))
        
        
        return Path(path.cgPath)
    }
    
    
}

#Preview {
    FeedCell(post: Post.mockPosts[0])
        .environmentObject(HomeViewModel(user: User.mockUsers[0]))
}
