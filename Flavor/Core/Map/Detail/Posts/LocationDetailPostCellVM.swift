//
//  LocationDetailPostCellVM.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-07-30.
//

import Foundation

class LocationDetailPostCellVM: ObservableObject {
    @Published var postId: String
    @Published var post: Post?
    @Published var detailVM: LocationDetailVM
    
    init(postId: String, detailVM: LocationDetailVM) {
        self.postId = postId
        self.detailVM = detailVM
    }
    
    
    func fetchPost() async throws {
        
        if let fetchedPost = try await PostService.fetchPost(postId){
            self.post = fetchedPost
            detailVM.fetchedPosts.append(fetchedPost)
        }
        
    }
}
