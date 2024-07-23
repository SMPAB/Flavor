//
//  TestPostCell.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-07-18.
//

import SwiftUI
import Photos

struct TestPostCell: View {
    
    @EnvironmentObject var viewModel: NewPostViewModel
    let asset: PHAsset
    @State private var image: UIImage?
    
    
    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 0
    @State private var offset: CGSize = .zero
    @State private var lastStoredOffset: CGSize = .zero
    @GestureState private var isInteracting: Bool = false
    
    @State var hideGrids = false
    
    @State var width = UIScreen.main.bounds.width
    
    var body: some View {
        
        ZStack{
            
            ImageCropView(hideGrids: false)
            
        }.frame(width: width, height: width)
            .background(.black)
        .onAppear{
           loadImage(asset: asset)
        }
        .onChange(of: viewModel.goToUpload) {
            if viewModel.goToUpload == true {
                let renderer = ImageRenderer(content: ImageCropView(hideGrids: true))
                renderer.proposedSize = .init(width: 5000, height: 5000)
                renderer.scale = 5
               
                if let image = renderer.uiImage{
                    
                   if let index = viewModel.selectedAssets.firstIndex(where: {$0 == asset}){
                        viewModel.Images.append(image)
                       viewModel.ImagesOrder.append(contentsOf: [imageOrder(image: image, order: index)])
                    }
                        
                    
                    
                } else {
                    
                }
            }
        }
        
       
            
    }
    
    
     func loadImage(asset: PHAsset) {
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true

        let size =  CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
       PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: options, resultHandler: {
            image, _ in
           
           self.image = image
        })
    }
    
    @ViewBuilder
    func Grids()->some View{
        ZStack{
            HStack{
                ForEach(1...5, id: \.self){ _ in
                    Rectangle()
                        .fill(.white.opacity(0.7))
                        .frame(width: 1)
                        .frame(maxWidth: .infinity)
                }
            }
            
            VStack{
                ForEach(1...8, id: \.self){ _ in
                    Rectangle()
                        .fill(.white.opacity(0.7))
                        .frame(height: 1)
                        .frame(maxHeight: .infinity)
                }
            }
        }
    }
    
    @ViewBuilder
    func ImageCropView(hideGrids: Bool = false)->some View{
        GeometryReader{
            let size = $0.size
            
            if let image{
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .overlay(content: {
                        GeometryReader { proxy in
                            let rect = proxy.frame(in: .named("CROPVIEW"))
                            
                            Color.clear
                            
                                .onChange(of: isInteracting) { newValue in
                                    
                                    
                                    withAnimation(.easeInOut(duration: 0.2)){
                                        if rect.minX > 0 {
                                            offset.width = (offset.width - rect.minX)
                                            haptics(.medium)
                                        }
                                        if rect.minY > 0 {
                                            offset.height = (offset.height - rect.minY)
                                            haptics(.medium)
                                        }
                                        
                                        if rect.maxX < size.width{
                                            offset.width = (rect.minX - offset.width)
                                            haptics(.medium)
                                        }
                                        
                                        if rect.maxY < size.height{
                                            offset.height = (rect.minY - offset.height)
                                            haptics(.medium)
                                        }
                                    }
                                    
                                    if !newValue{
                                        lastStoredOffset = offset
                                    }
                                }
                        }
                    })
                    .frame(width: size.width, height: size.width)
                    
            }
        }
        .scaleEffect(scale)
        .offset(offset)
        .overlay(content: {
            if !hideGrids{
                Grids()
            }
        })
        .coordinateSpace(name: "CROPVIEW")
        .gesture(
            DragGesture()
                .updating($isInteracting, body: {_, out, _ in
                    out = true
                }).onChanged({ value in
                    let translation = value.translation
                    offset = CGSize(width: translation.width + lastStoredOffset.width, height: translation.height + lastStoredOffset.height)
                })
                .onEnded({ _ in
                    lastStoredOffset = offset
                })
        )
        .gesture(
        MagnificationGesture()
            .updating($isInteracting, body: {_, out, _ in
                out = true
            }).onChanged({ value in
                let updatingScale = value + lastScale
                
                scale = (updatingScale < 1 ? 1 : updatingScale)
            }).onEnded({ value in
                withAnimation(.easeInOut(duration: 0.2)){
                    if scale < 1{
                        scale = 1
                        lastScale = 0
                    } else {
                        lastScale = scale - 1
                    }
                }
            })
        )
        .frame(width: width, height: width)
        .cornerRadius(0)
    }
}


struct PNG {
    private let data: Data
    
    init(_ data: Data) {
        self.data = data
    }
}

    // Transferable conformance, providing a DataRepresentation for ImageData.
@available(iOS 16.0, *)
extension PNG: Transferable {
    
    static var transferRepresentation: some TransferRepresentation {
        
        DataRepresentation<PNG>(contentType: .png) { imageData in
            imageData.data
        } importing: { data in
            PNG(data)
        }
    }
}


