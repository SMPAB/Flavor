//
//  TestPostPickerVM.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-07-18.
//


import SwiftUI
import Photos
import Firebase

@MainActor
class TestPostPickerVM: ObservableObject {
    @Published var selectedAsset: PHAsset?
    @Published var selectedAssets: [PHAsset] = []
    @Published var image: UIImage?
    @Published var multiPhoto: Bool = false
    @Published var imageSelected: Bool = false
    @Published var Images: [UIImage] = []

    @Published var searchText: String = ""

    private var imageLoader = ImageLoader()
    @Published var cameraController = CameraController()
    
    @Published var goToUpload = false
    
    
    @Published var cropImages = false
    
    
    
    func toggleMultiPhoto() {
        multiPhoto.toggle()
        selectedAsset = nil
        selectedAssets.removeAll()
    }

    func loadImage(asset: PHAsset, isThumbnail: Bool) {
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true

        let size = isThumbnail ? CGSize(width: 150, height: 150) : CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
        PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: options) { [weak self] image, _ in
            self?.image = image
        }
    }

    func fetchImage(from asset: PHAsset, completion: @escaping (UIImage?) -> Void) {
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true

        PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFill, options: options) { image, _ in
            completion(image)
        }
    }

    func fetchImages() {
        guard multiPhoto else {
            if let selectedAsset = selectedAsset {
                fetchImage(from: selectedAsset) { image in
                    if let image = image {
                        self.Images = [image]
                        self.imageSelected = true
                    }
                }
            }
            return
        }

        let imageManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = false
        requestOptions.deliveryMode = .highQualityFormat
        requestOptions.isNetworkAccessAllowed = true

        var images = [UIImage?](repeating: nil, count: selectedAssets.count)
        let group = DispatchGroup()

        for (index, asset) in selectedAssets.enumerated() {
            group.enter()
            let targetSize = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
            imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: requestOptions) { image, _ in
                DispatchQueue.main.async {
                    if let image = image {
                        images[index] = image
                    }
                    group.leave()
                }
            }
        }

        group.notify(queue: .main) {
            self.Images = images.compactMap { $0 }
            self.imageSelected = true
        }
    }
}
