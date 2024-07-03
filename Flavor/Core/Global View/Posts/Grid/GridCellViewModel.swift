//
//  GridCellViewModel.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-07-01.
//

import Foundation
import SwiftUI

class GridCellViewModel: ObservableObject {
    private var postId: String
    private var user: User
    private var profileVM: ProfileViewModel
    @Published var post: Post?
    
    //@Published var postsArray: [Post] = []
    

    
    init(postId: String, user: User, profileVM: ProfileViewModel) {
        self.postId = postId
        self.user = user
        self.profileVM = profileVM
  
    }
    
    @MainActor
    func fetchPost() async throws{
        
        
        if let post = try await PostService.fetchPostKnownUser(postId, user: user) {
            self.post = post
            
            if profileVM.album {
                profileVM.albumPosts.append(post)
            } else {
                
                if !profileVM.posts.contains(where: {$0.id == post.id}){
                    profileVM.posts.append(post)
                }
                
            }
               
            
               
            
           
        }
        
    }
}
