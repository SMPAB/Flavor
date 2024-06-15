//
//  FeedView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-13.
//

import SwiftUI

struct FeedView: View {
    
    @EnvironmentObject var viewModel: HomeViewModel
    var body: some View {
        VStack (spacing: 32){
            ForEach(viewModel.posts){ post in
                FeedCell(post: post)
                    .frame(width: UIScreen.main.bounds.width - 32)
                    .environmentObject(viewModel)
                    
                    .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.colorWhite)
                        .shadow(color: .colorOrange, radius: 3).opacity(0.2)
                    )
                    .padding(.horizontal, 16)
            }
            
            if viewModel.fetchingPosts {
                VStack{
                    
                    SkeletonPost()
                        .frame(width: UIScreen.main.bounds.width - 32)
                        .padding(.vertical, 16)
                        .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.colorWhite)
                            .shadow(color: .colorOrange, radius: 3).opacity(0.2)
                        )
                    
                    SkeletonPost()
                        .frame(width: UIScreen.main.bounds.width - 32)
                        .padding(.vertical, 16)
                        .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.colorWhite)
                            .shadow(color: .colorOrange, radius: 3).opacity(0.2)
                        )
                        
                }
            }
        }
    }
}

#Preview {
    FeedView()
        .environmentObject(HomeViewModel(user: User.mockUsers[0]))
}
