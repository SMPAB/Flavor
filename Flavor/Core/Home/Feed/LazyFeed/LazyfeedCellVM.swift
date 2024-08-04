//
//  LazyfeedCellVM.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-08-03.
//

import Foundation

class LazyfeedCellVM: ObservableObject {
    @Published var postId: String
    @Published var post: Post?
    @Published var triedfetchingPost = false
    
    init(postId: String) {
        self.postId = postId
    }
    
    func fetchPost() async throws {
        
        do {
            self.post = try await PostService.fetchPost(postId)
            triedfetchingPost = true
        } catch {
            triedfetchingPost = true
            return
        }
        
    }
}
