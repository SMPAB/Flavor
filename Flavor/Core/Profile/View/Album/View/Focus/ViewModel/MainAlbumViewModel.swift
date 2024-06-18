//
//  MainAlbumViewModel.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-16.
//

import Foundation

class MainAlbumViewModel: ObservableObject {
    @Published var album: Album
    private var lastPostFetched: String?
    @Published var fetchingAlbumPosts = false
    
    @Published var posts: [Post] = []
    
    @Published var profileVM: ProfileViewModel
    
    init(album: Album, profileVM: ProfileViewModel) {
        self.album = album
        self.profileVM = profileVM
    }
    
    func fetchAlbumPosts() async throws {
        fetchingAlbumPosts = true
        let (fetchedPosts, lastPostId) = try await PostService.fetchAlbumPosts(album, lastPostFetch: lastPostFetched)
        
        let newPosts = fetchedPosts.filter { fetchedPost in
            !self.posts.contains(where: { $0.id == fetchedPost.id})
        }
        
        self.posts.append(contentsOf: newPosts)
        self.lastPostFetched = lastPostId
        fetchingAlbumPosts = false
    }
}
