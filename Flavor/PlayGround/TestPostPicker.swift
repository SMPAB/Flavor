//
//  TestPostPicker.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-07-18.
//

import SwiftUI
import Iconoir
import Photos

struct TestPostPicker: View {
    
    @StateObject private var viewModel = TestPostPickerVM()
    @StateObject var controller = CameraController()
    
    @State var selectedAsset: PHAsset?
    
    var body: some View {
        
        let width = UIScreen.main.bounds.width
        NavigationStack {
            VStack {
                
                ZStack{
                    ForEach(viewModel.selectedAssets, id: \.self) { asset in
                        TestPostCell(asset: asset)
                            .zIndex(viewModel.selectedAsset == asset ? 100 : 1)
                            .environmentObject(viewModel)
                    }
                }.frame(height: width)
                /*TabView(selection: $selectedAsset){
                    
                
                }.tabViewStyle(.page(indexDisplayMode: .never))*/
                    
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
                
            } .navigationTitle("New Post")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarBackground(.white, for: .navigationBar)
                .toolbarColorScheme(.light, for: .navigationBar)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {
                        viewModel.goToUpload.toggle()
                    }) {
                        Text("Next")
                            .font(.custom("HankenGrotesk-Regular", size: .H4))
                            .foregroundStyle(Color(.colorOrange))
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading){
                    Button(action: {
                    }){
                        Iconoir.xmark.asImage.foregroundStyle(.black)
                    }
                }
            }
            .navigationDestination(isPresented: $viewModel.goToUpload){
                ScrollView(.horizontal) {
                    HStack{
                        ForEach(viewModel.Images, id: \.self){ image in
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipShape(Rectangle())
                        }
                    }
                }
            }
            //
            .onAppear {
                controller.getPhotoPermission()
                viewModel.cameraController.getPhotoPermission()
        }
            .onChange(of: viewModel.selectedAsset){
                withAnimation{
                    selectedAsset = viewModel.selectedAsset
                }
            }
        }
    }
    
    
    @ViewBuilder
    private var headerView: some View {
        HStack {
            Button(action: {
               // dismiss()
                
            }) {
                
                Iconoir.xmark.asImage.foregroundStyle(Color(.systemGray))
            }
            Spacer()
            Text("New Post")
                .font(.custom("HankenGrotesk-Regular", size: .H4))
                .fontWeight(.semibold)
            Spacer()
            Button(action: {
                viewModel.goToUpload.toggle()
            }) {
                Text("Next")
                    .font(.custom("HankenGrotesk-Regular", size: .H4))
                    .foregroundStyle(Color(.colorOrange))
            }
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
                    TestAssetImageView(asset: photo, isSelected: viewModel.selectedAsset == photo)
                        .environmentObject(viewModel)
                        .onTapGesture {
                           // if viewModel.multiPhoto {
                                if viewModel.selectedAssets.contains(photo){
                                    
                                    if viewModel.selectedAsset == photo {
                                        viewModel.selectedAssets.removeAll { $0 == photo }
                                        viewModel.selectedAsset = nil
                                    } else {
                                        viewModel.selectedAsset = photo
                                    }
                                   
                                } else {
                                    viewModel.selectedAssets.append(photo)
                                    viewModel.selectedAsset = photo
                                    withAnimation{
                                        print("DEBUG APP SELECTED ASSRT: \(photo)")
                                    }
                                    
                                }
                           /* } else {
                                viewModel.selectedAsset = (viewModel.selectedAsset == photo ? nil : photo)
                            }
                            if let asset = viewModel.selectedAsset {
                                viewModel.loadImage(asset: asset, isThumbnail: false)
                            }*/
                        }
                }
            }
        }
    }
}

#Preview {
    TestPostPicker()
}

struct TestAssetImageView: View {
    let width = UIScreen.main.bounds.width
    let asset: PHAsset
    let isSelected: Bool
    @StateObject private var imageLoader = ImageLoader()
    @EnvironmentObject var newPostVM: TestPostPickerVM
    
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
                            .opacity(newPostVM.selectedAsset != asset ? 1 : 0.5)
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
