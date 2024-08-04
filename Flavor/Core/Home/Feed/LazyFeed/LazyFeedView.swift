//
//  LazyFeedView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-08-03.
//

import SwiftUI

struct LazyFeedView: View {
    
    @EnvironmentObject var homeVM: HomeViewModel
    var body: some View {
        
        LazyVStack{
            ForEach(homeVM.feedPostIds, id: \.self) { id in
                LazyFeedCell(postId: id)
                    .environmentObject(homeVM)
            }
            
            ForEach(homeVM.publicFeedPosts){ post in
                FeedCell(post: post)
                    .environmentObject(homeVM)
                    .frame(width: UIScreen.main.bounds.width - 32)
                    .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.colorWhite)
                        .shadow(color: .colorOrange, radius: 3).opacity(0.2)
                    )
                    .padding(.horizontal, 16)
                    .onFirstAppear {
                        if homeVM.publicFeedPosts.last?.id == post.id {
                            Task {
                                print("DEBUG APP SHOULD FETCH MORE FEED POSTS")
                                try await homeVM.fetchPublicFeed()
                            }
                        }
                    }
            }
            
            if !homeVM.publicFeedPosts.isEmpty && homeVM.fetchingPublicPosts {
                Loading()
            }
        }
        
        
        
    }
}

#Preview {
    LazyFeedView()
}
