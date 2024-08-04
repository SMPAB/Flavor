//
//  LazyFeedCell.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-08-03.
//

import SwiftUI

struct LazyFeedCell: View {
    
    @StateObject var viewModel: LazyfeedCellVM
    @EnvironmentObject var homeVM: HomeViewModel
    
    init(postId: String) {
        self._viewModel = StateObject(wrappedValue: LazyfeedCellVM(postId: postId))
    }
    var body: some View {
        
        let width = UIScreen.main.bounds.width
        
        ZStack{
            if let post = viewModel.post {
                FeedCell(post: post)
                    .environmentObject(homeVM)
                    .frame(width: width - 32)
                    .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.colorWhite)
                        .shadow(color: .colorOrange, radius: 3).opacity(0.2)
                    )
                    .padding(.horizontal, 16)
                    .onFirstAppear{
                        Task {
                            try await PostService.removePostIdFromUserFeed(username: homeVM.user.userName, postId: viewModel.postId)
                        }
                    }
                    
            } else {
                SkeletonPost()
                    .frame(width: UIScreen.main.bounds.width - 32)
                    .padding(.vertical, 16)
                    .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.colorWhite)
                        .shadow(color: .colorOrange, radius: 3).opacity(0.2)
                    )
            }
        }.onAppear{
            Task {
                try await viewModel.fetchPost()
            }
        }
        .onChange(of: viewModel.triedfetchingPost){
            if viewModel.triedfetchingPost == true && viewModel.post == nil {
                Task {
                    homeVM.feedPostIds.removeAll(where: {$0 == viewModel.postId})
                    try await PostService.removePostIdFromUserFeed(username: homeVM.user.userName, postId: viewModel.postId)
                }
            }
        }
    }
}

#Preview {
    LazyFeedCell(postId: "kasdklnanclsalkc")
        .environmentObject(HomeViewModel(user: User.mockUsers[0]))
}
