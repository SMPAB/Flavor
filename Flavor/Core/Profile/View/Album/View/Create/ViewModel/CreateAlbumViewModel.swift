//
//  CreateAlbumViewModel.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-15.
//

import Foundation
import SwiftUI
import Firebase

class CreateAlbumViewModel: ObservableObject {
    @Published var user: User
    
    @Published var showImagePicker = false
    @Published var image: Image?
    @Published var uiImage: UIImage?
    
    @Published var title = ""
    
    @Published var allosts: [Post] = []
    @Published var selectedPosts: [Post] = []
    
    @Published var profileVM: ProfileViewModel
    
    
    
    init(user: User, profileVM: ProfileViewModel) {
        self.user = user
        self.profileVM = profileVM
    }
    
    func createAlbum() async throws {
        
        do {
            let docID = FirebaseConstants.AlbumCollection.document().documentID
            
            let sortedPosts = selectedPosts.sorted(by: {$0.timestamp.dateValue() > $1.timestamp.dateValue()})
            var uploadIds = sortedPosts.map { $0.id }
            var album = Album(id: docID, ownerUid: user.id, imageUrl: nil, timestamp: Timestamp(date: Date()), title: title, uploadIds: uploadIds)
            
            if let uiImage = uiImage{
                   let imageUrl = try await ImageUploader.uploadImage(image: uiImage)
                album.imageUrl = imageUrl
                
            }
            
            guard let albumData = try? Firestore.Encoder().encode(album) else { return }
            try await FirebaseConstants.AlbumCollection.document(docID).setData(albumData)
            
            var albumtodisplay = album
            albumtodisplay.user = profileVM.user
            profileVM.albums.insert(albumtodisplay, at: 0)
            
            for i in 0..<uploadIds.count {
                try await FirebaseConstants.PostCollection.document(uploadIds[i]).setData(["Albums": FieldValue.arrayUnion([album.id])], merge: true)
            }
            
        } catch {
            return
        }
        
    }
    
}
