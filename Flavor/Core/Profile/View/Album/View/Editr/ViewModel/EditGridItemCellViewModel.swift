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
    
    init(postId: String, mainVM: EditAlbumViewModel) {
        self.postId = postId
        self.mainVM = mainVM
        self.selectedPosts = mainVM.selectedPosts
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
            selectedPosts.removeAll(where: {$0.id == postId})
            //print("DEBUG APP SELECTED POSTS \(mainVM.selectedPosts.count)")
        } else {
            mainVM.selectedPosts.append(post!)
            selectedPosts.append(post!)
           // print("DEBUG APP POSTS \(mainVM.selectedPosts.count)")
           
        }
    }
    
    
}
