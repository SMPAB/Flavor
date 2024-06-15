//
//  ImagePickerOptions.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-12.
//

import SwiftUI
import PhotosUI

struct ImagePickerOptions: View {
    
    @StateObject var viewModel: ImagePickerViewModel
    
    init(image: Binding<Image?>, uiimage: Binding<UIImage?>, showView: Binding<Bool>, imageType: ImageType){
        self._viewModel = StateObject(wrappedValue: ImagePickerViewModel(image: image, uiImage: uiimage, showView: showView, imageType: imageType))
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.2)
                .ignoresSafeArea(.all)
                .onTapGesture {
                    viewModel.showView = false
                }
            
            if viewModel.chooseFromLibrary {
                if let image = viewModel.selectedImage {
                    CropView(image: image)
                    { croppedImage, status in
                        if let croppedImage = croppedImage {
                            viewModel.endUIImage = croppedImage
                            viewModel.chooseFromLibrary = false
                            viewModel.processSelectedImage()
                        }
                    }
                    .environmentObject(viewModel)
                }
            }
            
        }
        /*.sheet(isPresented: $viewModel.showSelectionSheet) {
            /*SelectionSheet()
                .environmentObject(viewModel)
                .presentationDetents([.height(200)])*/
        }*/
        .photosPicker(isPresented: $viewModel.showImagePicker, selection: $viewModel.photosItem)
        .onChange(of: viewModel.photosItem) { newValue in
            if let newValue = newValue {
                Task {
                    if let imageData = try? await newValue.loadTransferable(type: Data.self),
                       let image = UIImage(data: imageData) {
                        await MainActor.run {
                            viewModel.selectedImage = image
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ImagePickerOptions(image: .constant(nil), uiimage: .constant(nil), showView: .constant(true), imageType: .albumImage)
}
