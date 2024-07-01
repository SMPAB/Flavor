//
//  GridCellViewModel.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-07-01.
//

import Foundation

class GridCellViewModel: ObservableObject {
    private var postId: String
    private var user: User
    private var profileVM: ProfileViewModel
    @Published var post: Post?
    
    init(postId: String, user: User, profileVM: ProfileViewModel) {
        self.postId = postId
        self.user = user
        self.profileVM = profileVM
    }
    
    func fetchPost() async throws{
        
        
        if let post = try await PostService.fetchPostKnownUser(postId, user: user) {
            self.post = post
            profileVM.posts.append(post)
        }
        
    }
}
