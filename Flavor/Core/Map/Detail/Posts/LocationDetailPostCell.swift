//
//  LocationDetailPostCell.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-07-30.
//

import SwiftUI
import Kingfisher

struct LocationDetailPostCell: View {
    
    
    @StateObject var viewModel: LocationDetailPostCellVM
    @EnvironmentObject var sceneController: SceneController
    
    init(postId: String, detailVM: LocationDetailVM){
        self._viewModel = StateObject(wrappedValue: LocationDetailPostCellVM(postId: postId, detailVM: detailVM))
    }
    
    @Namespace var namespace
    var body: some View {
        ZStack{
            if let post = viewModel.post {
                //ImageView(size: .xlarge, imageUrl: post.imageUrls?[0], background: false)
                
                if let imageUrls = post.imageUrls {
                    KFImage(URL(string: imageUrls[0]))
                        .resizable()
                        .scaledToFill()
                        .matchedGeometryEffect(id: post.id, in: namespace)
                        .frame(width: 128, height: 128)
                        .clipShape(RoundedRectangle(cornerRadius: 128/8))
                        .contentShape(RoundedRectangle(cornerRadius: 128/8))
                        .onTapGesture {
                            withAnimation{
                                
                                
                               // viewModel.detailVM.mapVM.maxHeightSheet = true
                                //viewModel.detailVM.showPosts = true
                                //viewModel.detailVM.selectedPost = post
                                sceneController.selectedPost = post
                                sceneController.showPost = true
                                sceneController.hideOverlay.toggle()
                                
                               
                                print("DEBUG APP SCENE CONTROLLER OVERLAYS: \(sceneController.hideOverlay)")
                            }
                        }
                }
                    
            } else {
                ImageView(size: .xlarge, imageUrl: viewModel.post?.imageUrls?[0], background: false)
            }
        }.frame(height: 140)
            .onFirstAppear {
                Task {
                    try await viewModel.fetchPost()
                }
            }
        
            
        
            
    }
}


