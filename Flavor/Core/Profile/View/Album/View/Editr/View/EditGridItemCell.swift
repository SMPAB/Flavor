//
//  EditGridItemCell.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-16.
//

import SwiftUI
import Kingfisher

struct EditGridItemCell: View {
    
    @StateObject var viewModel: EditGridItemCellViewModel
    
    init(postId: String, mainVM: EditAlbumViewModel){
        self._viewModel = StateObject(wrappedValue: EditGridItemCellViewModel(postId: postId, mainVM: mainVM))
    }
    
    
    var body: some View {
        
        let width = UIScreen.main.bounds.width
        let frameWidth = (width-3)/3
        let frameHeight = ((width-3)/3) * 5/4
        ZStack{
            if let post = viewModel.post {
                
                var isSelected: Bool {
                   // return viewModel..contains(post)
                    return viewModel.selectedPostsId.contains(post.id)
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
                        .onAppear{
                            if isSelected {
                                
                                if !viewModel.selectedPosts.contains(where: {$0.id == post.id}){
                                    viewModel.selectedPosts.append(post)
                                    viewModel.mainVM.selectedPosts.append(post)
                                }
                                
                            }
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
/*
#Preview {
    EditGridItemCell()
}
*/
