//
//  CreateAlbumView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-15.
//

import SwiftUI

struct CreateAlbumView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: CreateAlbumViewModel
    
    private let gridItems: [GridItem] = [
    
        .init(.flexible(), spacing: 1),
        .init(.flexible(), spacing: 1),
        .init(.flexible(), spacing: 1)
    ]
    
    @State var uploading = false
    
    init(user: User, profileVM: ProfileViewModel){
        self._viewModel = StateObject(wrappedValue: CreateAlbumViewModel(user: user, profileVM: profileVM))
    }
    var body: some View {
        
        let width = UIScreen.main.bounds.width
        ZStack {
            
                VStack(spacing: 16){
                    HeaderMain( action: {
                        if !uploading {
                            Task{
                                uploading = true
                                try await viewModel.createAlbum()
                                dismiss()
                                uploading = false
                            }
                        }
                        
                    }, cancelText: "Cancel", title: "Create Album", actionText: "Create")
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
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.systemGray6))
                            .frame(width: 96, height: 96)
                            .onTapGesture {
                                viewModel.showImagePicker.toggle()
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
                                ForEach(viewModel.user.postIds ?? [], id: \.self){ postId in
                                    CreateGridItemCell(postId: postId, mainVM: viewModel)
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

#Preview {
    CreateAlbumView(user: User.mockUsers[0], profileVM: ProfileViewModel(user: User.mockUsers[0]))
}
