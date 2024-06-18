//
//  CameraController.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-17.
//
import Foundation
import Photos
import SwiftUI
import Combine

class CameraController: ObservableObject {
    
    @Published var hasPhotoAccess: Bool = false
    @Published var allPhotosInCurrentAlbum: [PHAsset] = []
    private var smartAlbums = [PHAssetCollection]()
    private var userCreatedAlbums = PHFetchResult<PHAssetCollection>()
    private let listOfsmartAlbumSubtypesToBeFetched: [PHAssetCollectionSubtype]  = [.smartAlbumUserLibrary, .smartAlbumFavorites, .smartAlbumVideos, .smartAlbumScreenshots]
    
    @MainActor
    func getPhotoPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        
        if status == .authorized || status == .limited {
            self.hasPhotoAccess = true
            self.fetchPhotoLibraryAssets()
            return
        }

        PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
                switch newStatus {
                case .authorized, .limited:
                    self.hasPhotoAccess = true
                    self.fetchPhotoLibraryAssets()
                case .notDetermined, .restricted, .denied:
                    self.hasPhotoAccess = false
                @unknown default:
                    fatalError("Unknown authorization status")
                }
            
        }
    }

    
    @MainActor
    func fetchPhotoLibraryAssets() {
        print("DEBUG APP SHOULD FETCH 1")
        let authStatus = PHPhotoLibrary.authorizationStatus()
        guard authStatus ==  .authorized || authStatus == .limited else { return }
        
        
        print("DEBUG APP SHOULD FETCH 2")
        for collectionSubType in listOfsmartAlbumSubtypesToBeFetched {
            if let smartAlbum = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: collectionSubType, options: nil).firstObject {
                smartAlbums.append(smartAlbum)
            }
        }
        
        print("DEBUG APP SHOULD FETCH 3")
        let userCreatedAlbumsOptions = PHFetchOptions()
        userCreatedAlbumsOptions.predicate = NSPredicate(format: "estimatedAssetCount > 0")
        userCreatedAlbums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: userCreatedAlbumsOptions)
        
        let fetchOptions = PHFetchOptions()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOptions.sortDescriptors = [sortDescriptor]
        let fetchedAssets = PHAsset.fetchAssets(with: fetchOptions)
        
        // Convert PHFetchResult to Array
        var assetsArray: [PHAsset] = []
        fetchedAssets.enumerateObjects { (object, _, _) in
            assetsArray.append(object)
        }
        
        
            self.allPhotosInCurrentAlbum = assetsArray
            print("DEBUG APP SHOULD FETCH 4: count\(self.allPhotosInCurrentAlbum.count)")
        
        
    }
}

