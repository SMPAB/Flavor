//
//  EditAlbumViewModel.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-16.
//

import Foundation
import SwiftUI

class EditAlbumViewModel: ObservableObject {
    @Published var showImagePicker = false
    @Published var image: Image?
    @Published var uiImage: UIImage?
    
    @Published var title = ""
    
    @Published var allosts: [Post] = []
    
    @Published var originalPosts: [Post] = []
    
    @Published var selectedPosts: [Post] = []
    
    @Published var albumViewModel: MainAlbumViewModel
    
    
    
    init(albumViewModel: MainAlbumViewModel) {
        self.albumViewModel = albumViewModel
        self.title = albumViewModel.album.title

        self.originalPosts = albumViewModel.posts
        self.selectedPosts = albumViewModel.posts
    }
    
    @MainActor
    func editAlbum() async throws {
        do {
            
            var data = [String:Any]()
            
            if let uiImage = uiImage{
                   let imageUrl = try await ImageUploader.uploadImage(image: uiImage)
                    data["imageUrl"] = imageUrl
                albumViewModel.album.imageUrl = imageUrl
                
                if let index = albumViewModel.profileVM.albums.firstIndex(where: { $0.id == albumViewModel.album.id }) {
                                    albumViewModel.profileVM.albums[index].imageUrl = imageUrl
                    }
                
            }
            
            if title != albumViewModel.album.title {
                data["title"] = title
                albumViewModel.album.title = title
                
                if let index = albumViewModel.profileVM.albums.firstIndex(where: { $0.id == albumViewModel.album.id }) {
                                    albumViewModel.profileVM.albums[index].title = title
                    }
            }
            
            var sortedPosts = selectedPosts.sorted(by: {$0.timestamp.dateValue() > $1.timestamp.dateValue()})
            let sortedPostIds = sortedPosts.map { $0.id }
            data["uploadIds"] = sortedPostIds
            
            albumViewModel.posts = sortedPosts
            
            try await FirebaseConstants.AlbumCollection.document(albumViewModel.album.id).updateData(data)
            
            if let index = albumViewModel.profileVM.albums.firstIndex(where: { $0.id == albumViewModel.album.id }) {
                                albumViewModel.profileVM.albums[index].uploadIds = sortedPostIds
                }
            
        } catch {
            return
        }
        
    }
    
}
