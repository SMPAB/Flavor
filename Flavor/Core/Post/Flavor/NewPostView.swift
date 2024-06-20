//
//  NewPostView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-17.
//

import SwiftUI
import Photos
import Iconoir

struct NewPostView: View {
    @StateObject private var viewModel = NewPostViewModel()
    @StateObject var controller = CameraController()
    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 0
    @State private var offset: CGSize = .zero
    @State private var lastStoredOffset: CGSize = .zero
    @GestureState private var isInteracting: Bool = false

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var homeVM: HomeViewModel
    
    @Binding var showOptions: Bool

    var body: some View {
        NavigationStack {
            VStack {
                headerView
                    .padding(.horizontal, 16)
                imageView
                    .padding(.horizontal, 16)
                footerView
                    .padding(.horizontal, 16)
                if controller.hasPhotoAccess {
                    photosGridView
                } else {
                    Text("No access to Photos. Please enable access in Settings.")
                        .onTapGesture {
                            viewModel.cameraController.getPhotoPermission()
                        }
                    Spacer()
                }
                
            }.navigationDestination(isPresented: $viewModel.goToUpload){
                UploadPostView(images: $viewModel.Images, showOption: $showOptions)
                    .environmentObject(homeVM)
            }
            //
            .onAppear {
                controller.getPhotoPermission()
                viewModel.cameraController.getPhotoPermission()
        }
        }
    }

    @ViewBuilder
    private var headerView: some View {
        HStack {
            Button(action: { 
                showOptions = true
                dismiss()
                
            }) {
                
                Iconoir.xmark.asImage.foregroundStyle(Color(.systemGray))
            }
            Spacer()
            Text("New Post")
                .font(.custom("HankenGrotesk-Regular", size: .H4))
                .fontWeight(.semibold)
            Spacer()
            Button(action: {
                viewModel.fetchImages()
                viewModel.goToUpload.toggle()
                showOptions = false
            }) {
                Text("Next")
                    .font(.custom("HankenGrotesk-Regular", size: .H4))
                    .foregroundStyle(Color(.colorOrange))
            }
        }
    }

    @ViewBuilder
    private var imageView: some View {
        if let image = viewModel.image {
            ZStack {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width - 32, height: 400)
                    .scaleEffect(scale)
                    .offset(offset)
                    .coordinateSpace(name: "Image")
                    /*.gesture(
                        DragGesture()
                            .updating($isInteracting) { _, out, _ in out = true }
                            .onChanged { value in
                                let translation = value.translation
                                offset = CGSize(width: translation.width + lastStoredOffset.width, height: translation.height + lastStoredOffset.height)
                            }
                    )
                    .gesture(
                        MagnificationGesture()
                            .updating($isInteracting) { _, out, _ in out = true }
                            .onChanged { value in
                                let updatedScale = value + lastScale
                                scale = max(updatedScale, 1)
                            }
                            .onEnded { value in
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    lastScale = scale - 1
                                }
                            }
                    )*/
            }
            .background(Color.black)
            .cornerRadius(16)
            .contentShape(RoundedRectangle(cornerRadius: 16))
        } else {
            RoundedRectangle(cornerRadius: 16)
                .frame(width: UIScreen.main.bounds.width - 32, height: 400)
                .background(Color.black)
                .cornerRadius(16)
        }
    }

    @ViewBuilder
    private var footerView: some View {
        HStack {
            Text("Your Photos:")
                .font(.custom("HankenGrotesk-Regular", size: .H4))
                .fontWeight(.semibold)
            Spacer()
            Button(action: { viewModel.toggleMultiPhoto() }) {
                Iconoir.mediaImageList.asImage
                    .foregroundStyle(viewModel.multiPhoto ? Color(.colorWhite) : Color.black)
                    .background(
                        Circle()
                            .fill(viewModel.multiPhoto ? Color(.colorOrange) : Color.clear)
                            .frame(width: 32, height: 32)
                    )
            }
            .padding(.horizontal, 5)
            Iconoir.camera.asImage.onTapGesture {
                // Camera action
            }
        }
    }

    @ViewBuilder
    private var photosGridView: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 1) {
                ForEach(viewModel.cameraController.allPhotosInCurrentAlbum, id: \.self) { photo in
                    AssetImageView(asset: photo, isSelected: viewModel.selectedAsset == photo)
                        .environmentObject(viewModel)
                        .onTapGesture {
                            if viewModel.multiPhoto {
                                if viewModel.selectedAssets.contains(photo) {
                                    viewModel.selectedAssets.removeAll { $0 == photo }
                                    viewModel.selectedAsset = nil
                                } else {
                                    viewModel.selectedAssets.append(photo)
                                    viewModel.selectedAsset = photo
                                }
                            } else {
                                viewModel.selectedAsset = (viewModel.selectedAsset == photo ? nil : photo)
                            }
                            if let asset = viewModel.selectedAsset {
                                viewModel.loadImage(asset: asset, isThumbnail: false)
                            }
                        }
                }
            }
        }
    }
}


    

private let itemFormatter: DateFormatter = {
let formatter = DateFormatter()
formatter.dateStyle = .short
formatter.timeStyle = .medium
return formatter
}()


class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    
    static let cache = NSCache<NSString, UIImage>()

    func loadImage(asset: PHAsset, isThumbnail: Bool = false ) {
        let assetIdentifier = asset.localIdentifier
        if let cachedImage = ImageLoader.cache.object(forKey: NSString(string: assetIdentifier)) {
            self.image = cachedImage
            return
        }

        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.version = .current
        options.deliveryMode = .opportunistic
        options.isNetworkAccessAllowed = true
        options.resizeMode = .exact
        options.isSynchronous = false

        let targetSize = isThumbnail ? CGSize(width: 100, height: 100) : CGSize(width: 5000, height: 5000)// Thumbnail size

        manager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) { image, info in
            guard let image = image, info?[PHImageErrorKey] == nil else { return }
            DispatchQueue.main.async {
                ImageLoader.cache.setObject(image, forKey: NSString(string: assetIdentifier))
                self.image = image
            }
        }
    }

}

import SwiftUI
import Photos

struct AssetImageView: View {
    let width = UIScreen.main.bounds.width
    let asset: PHAsset
    let isSelected: Bool
    @StateObject private var imageLoader = ImageLoader()
    @EnvironmentObject var newPostVM: NewPostViewModel
    
    var body: some View {
        ZStack {
            
            if newPostVM.selectedAssets.contains(asset){
                ZStack(alignment: .topTrailing){
                    if let image = imageLoader.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: width/4, height: width/4 - 4)
                            .contentShape(RoundedRectangle(cornerRadius: 0))
                            .clipShape(RoundedRectangle(cornerRadius: 0))
                            .opacity(0.5)
                    } else {
                        Rectangle()
                            .fill(Color(.systemGray6))
                            .frame(width: width/4, height: width/4 - 4)
                    }
                    
                    if let index = newPostVM.selectedAssets.firstIndex(of: asset) {
                        ZStack{
                            Image(systemName: "circle.fill")
                                .foregroundStyle(.blue)
                            
                            Text("\(index + 1)")
                                .font(.primaryFont(.P2))
                                .foregroundStyle(.colorWhite)
                        }.padding(4)
                    }
                }
                
            } else {
                if let image = imageLoader.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: width/4, height: width/4 - 4)
                        .contentShape(RoundedRectangle(cornerRadius: 0))
                        .clipShape(RoundedRectangle(cornerRadius: 0))
                        .opacity(isSelected ? 0.5 : 1)
                } else {
                    Rectangle()
                        .fill(Color(.systemGray6))
                        .frame(width: width/4, height: width/4 - 4)
                }
            }
            
        }
        .onAppear {
            imageLoader.loadImage(asset: asset, isThumbnail: true)
        }
    }
}



/*
#Preview {
    NewPostView()
}
*/
