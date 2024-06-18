//
//  EditAlbumView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-16.
//

import SwiftUI
import Kingfisher

struct EditAlbumView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: EditAlbumViewModel
    
    private let gridItems: [GridItem] = [
    
        .init(.flexible(), spacing: 1),
        .init(.flexible(), spacing: 1),
        .init(.flexible(), spacing: 1)
    ]
    
    @State var uploading = false
    
    init(albumVM: MainAlbumViewModel){
        self._viewModel = StateObject(wrappedValue: EditAlbumViewModel(albumViewModel: albumVM))
    }
    var body: some View {
        
        let width = UIScreen.main.bounds.width
        ZStack {
            
                VStack(spacing: 16){
                    HeaderMain( action: {
                        if !uploading {
                            Task{
                                uploading = true
                                try await viewModel.editAlbum()
                                dismiss()
                                uploading = false
                            }
                        }
                        
                    }, cancelText: "Cancel", title: "Edit Album", actionText: "Save")
                    .padding(.horizontal, 16)
                    
                    if let image = viewModel.image {
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 96, height: 96)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .contentShape(RoundedRectangle(cornerRadius: 8))
                            .onTapGesture {
                                viewModel.showImagePicker.toggle()
                            }
                    } else {
                        
                        if let imageUrl = viewModel.albumViewModel.album.imageUrl{
                            KFImage(URL(string: imageUrl))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 96, height: 96)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .contentShape(RoundedRectangle(cornerRadius: 8))
                                .onTapGesture {
                                    viewModel.showImagePicker.toggle()
                                }
                        } else {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.systemGray6))
                                .frame(width: 96, height: 96)
                                .onTapGesture {
                                    viewModel.showImagePicker.toggle()
                                }
                        }
                        
                    }
                    
                    VStack(alignment: .leading, spacing: 8){
                        Text("Album name")
                            .font(.primaryFont(.P1))
                            .fontWeight(.semibold)
                        
                        CustomTextField(text: $viewModel.title, textInfo: "Write album name...", secureField: false, multiRow: false)
                    }.padding(.horizontal, 16)
                    
                    LazyVStack(spacing: 0){
                        Text("Choose Flavors")
                            .font(.primaryFont(.P1))
                            .fontWeight(.semibold)
                        
                        Rectangle()
                            .fill(Color(.systemGray))
                            .frame(height: 1)
                            
                        
                        ScrollView {
                            LazyVGrid(columns: gridItems, spacing: 1) {
                                ForEach(viewModel.albumViewModel.album.user?.postIds ?? [], id: \.self){ postId in
                                    EditGridItemCell(postId: postId, mainVM: viewModel)
                                    //Text(postId)
                                }
                            }
                        }.frame(maxHeight: .infinity)
                    }
                    Spacer()
                 
                }
            
            
            if viewModel.showImagePicker{
                ImagePickerOptions(image: $viewModel.image, uiimage: $viewModel.uiImage, showView: $viewModel.showImagePicker, imageType: .albumImage)
            }
            
           
            
        }.onTapGesture {
            UIApplication.shared.endEditing()
        }
          
    }
}
/*
#Preview {
    EditAlbumView(albumVM: MainAlbumViewModel(album: <#T##Album#>))
}*/
