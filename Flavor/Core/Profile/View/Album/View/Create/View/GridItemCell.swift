//
//  GridItemCell.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-16.
//

import SwiftUI
import Kingfisher


struct CreateGridItemCell: View {
    
    @StateObject var viewModel: CreateGridItemCellViewModel
    
    init(postId: String, mainVM: CreateAlbumViewModel){
        self._viewModel = StateObject(wrappedValue: CreateGridItemCellViewModel(postId: postId, mainVM: mainVM))
    }
    
    
    var body: some View {
        
        let width = UIScreen.main.bounds.width
        let frameWidth = (width-3)/3
        let frameHeight = ((width-3)/3) * 5/4
        ZStack{
            if let post = viewModel.post {
                
                var isSelected: Bool {
                    return viewModel.selectedPosts.contains(post)
                }
                
                ZStack{
                    if let imageUrls = post.imageUrls {
                        ZStack (alignment: .topTrailing){
                            KFImage(URL(string: imageUrls[0]))
                                .resizable()
                                .scaledToFill()
                                .frame(width: frameWidth, height: frameHeight)
                                .clipShape(RoundedRectangle(cornerRadius: 0))
                                .contentShape(RoundedRectangle(cornerRadius: 0))
                            .opacity(isSelected ? 0.7 : 1)
                            
                            if isSelected{
                                Image(systemName: "checkmark.circle.fill")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 16, height: 16)
                                    .foregroundStyle(.colorOrange)
                                    .background(Circle().fill(.colorWhite))
                                    .padding(4)
                            } else {
                                Image(systemName: "circle")
                                    .resizable()
                                    .foregroundStyle(.colorWhite)
                                    .scaledToFill()
                                    .frame(width: 16, height: 16)
                                    .padding(4)
                            }
                        }.onTapGesture {
                            viewModel.handleTapp(isSelected: isSelected)
                        }
                    }
                }
                
            } else {
                RoundedRectangle(cornerRadius: 0)
                    .fill(Color(.systemGray6))
                    .frame(width: frameWidth, height: frameHeight)
            }
        }.onFirstAppear {
            Task{
               try await viewModel.fetchPost()
            }
        }
    }
}

#Preview {
    CreateGridItemCell(postId: "postId", mainVM: CreateAlbumViewModel(user: User.mockUsers[0], profileVM: ProfileViewModel(user: User.mockUsers[0])))
}
