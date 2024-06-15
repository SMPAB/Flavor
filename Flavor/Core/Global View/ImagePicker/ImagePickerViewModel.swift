//
//  ImagePickerViewModel.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-12.
//

import Foundation
import PhotosUI
import SwiftUI

class ImagePickerViewModel: ObservableObject {
    @Binding var endProductPhoto: Image?
    @Binding var showView: Bool
    @Binding var endUIImage: UIImage?
    
    @Published var title = ""
    @Published var showSelectionSheet = false
    @Published var chooseFromLibrary = true
    @Published var takeImage = false
    @Published var showImagePicker = true
    @Published var selectedImage: UIImage?
    @Published var photosItem: PhotosPickerItem?
    
    init(image: Binding<Image?>, uiImage: Binding<UIImage?>, showView: Binding<Bool>, imageType: ImageType) {
        self._endProductPhoto = image
        self._showView = showView
        self._endUIImage = uiImage
        self.setTitle(for: imageType)
    }
    
    private func setTitle(for type: ImageType) {
        switch type {
        case .profileImage:
            self.title = "Select profile image"
        case .albumImage:
            self.title = "Select album cover"
        case .groupImage:
            self.title = "Select crew image"
        }
    }
    
    func processSelectedImage() {
        guard let endUIImage = endUIImage else { return }
        endProductPhoto = Image(uiImage: endUIImage)
        showView = false
    }
}

enum ImageType {
    case profileImage
    case groupImage
    case albumImage
}

