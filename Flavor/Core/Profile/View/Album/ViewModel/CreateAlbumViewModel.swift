//
//  CreateAlbumViewModel.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-15.
//

import Foundation
import SwiftUI

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
    
}
