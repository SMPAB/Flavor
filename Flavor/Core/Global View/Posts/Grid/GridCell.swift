//
//  GridCell.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-07-01.
//

import SwiftUI
import Kingfisher

struct GridCell: View {
    
    
    
    let widthMultiplier: Int
    let heightMultiplier: Int
    let cornerRadius: CGFloat
    
    @State var width = UIScreen.main.bounds.width
    
    @StateObject var viewModel: GridCellViewModel
    
    init(user: User, postId: String, profileVM: ProfileViewModel, widthMultiplier: Int, heightMultiplier: Int, cornerRadius: CGFloat) {
        self._viewModel = StateObject(wrappedValue: GridCellViewModel(postId: postId, user: user, profileVM: profileVM))
        self.widthMultiplier = widthMultiplier
        self.heightMultiplier = heightMultiplier
        self.cornerRadius = cornerRadius
    }
    var body: some View {
        ZStack{
            if let post = viewModel.post {
                if let imageUrls = post.imageUrls {
                    KFImage(URL(string: imageUrls[0]))
                        .resizable()
                        .scaledToFill()
                        .frame(width: width * CGFloat(widthMultiplier/390), height: width * CGFloat(widthMultiplier/390))
                        .contentShape(RoundedRectangle(cornerRadius: cornerRadius))
                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                }
            } else {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color(.systemGray6))
                    .frame(width: width * CGFloat(widthMultiplier/390), height: width * CGFloat(widthMultiplier/390))
            }
        }.onFirstAppear {
            Task{
                try await viewModel.fetchPost()
            }
        }
    }
}
/*
#Preview {
    GridCell(user: User.mockUsers[0], widthMultiplier: 120, heightMultiplier: 120)
}*/
