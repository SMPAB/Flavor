//
//  EditGridItemCellViewModel.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-16.
//

import Foundation

class EditGridItemCellViewModel: ObservableObject{
    private var postId: String
    @Published var post: Post?
    @Published var mainVM: EditAlbumViewModel
    
    
    
    @Published var selectedPosts: [Post] = []
    @Published var selectedPostsId: [String] = []
    
    init(postId: String, mainVM: EditAlbumViewModel) {
        self.postId = postId
        self.mainVM = mainVM
        self.selectedPosts = mainVM.selectedPosts
        self.selectedPostsId = mainVM.selectedPostIds
        //self.originalPosts = mainVM.posts
    }
    
    @MainActor
    func fetchPost() async throws {
        self.post = try await PostService.fetchPost(postId)
        
    }
    
    @MainActor
    func handleTapp(isSelected: Bool) {
        
        guard post != nil else { return }
        
        if isSelected {
            
            mainVM.selectedPosts.removeAll(where: {$0.id == postId})
            mainVM.selectedPostIds.removeAll(where: {$0 == postId})
            selectedPosts.removeAll(where: {$0.id == postId})
            selectedPostsId.removeAll(where: {$0 == postId})
            
            //print("DEBUG APP SELECTED POSTS \(mainVM.selectedPosts.count)")
        } else {
            mainVM.selectedPosts.append(post!)
            selectedPosts.append(post!)
            mainVM.selectedPostIds.append(post!.id)
            selectedPostsId.append(post!.id)
           // print("DEBUG APP POSTS \(mainVM.selectedPosts.count)")
           
        }
    }
    
    
}
