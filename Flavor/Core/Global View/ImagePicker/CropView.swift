//
//  CropView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-12.
//

import SwiftUI

struct CropView: View {
    
    
   
    var image: UIImage?
    var onCrop: (UIImage?,Bool)->()
    
    
    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 0
    @State private var offset: CGSize = .zero
    @State private var lastStoredOffset: CGSize = .zero
    @GestureState private var isInteracting: Bool = false
    
    @EnvironmentObject var viewModel: ImagePickerViewModel
    
    var body: some View {
        NavigationStack {
            ImageCropView()
                .navigationTitle("Crop View")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarBackground(.black, for: .navigationBar)
                .toolbarColorScheme(.dark, for: .navigationBar)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.ignoresSafeArea())
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: {
                        let renderer = ImageRenderer(content: ImageCropView(hideGrids: true))
                        renderer.proposedSize = .init(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.width * 0.9)
                        if let image = renderer.uiImage{
                            onCrop(image,true)
                        } else {
                            onCrop(nil, false)
                        }
                        viewModel.showView = false
                    }){
                        Image(systemName: "checkmark")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading){
                    Button(action: {
                        viewModel.showView = false
                    }){
                        Image(systemName: "xmark")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func ImageCropView(hideGrids: Bool = false)->some View{
        let width = UIScreen.main.bounds.width
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
        .frame(width: width * 0.9, height: width * 0.9)
        .cornerRadius(0)
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
}

extension View{

    func haptics(_ style: UIImpactFeedbackGenerator.FeedbackStyle){
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
}


