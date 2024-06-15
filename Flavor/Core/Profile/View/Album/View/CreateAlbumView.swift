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
    
    init(user: User, profileVM: ProfileViewModel){
        self._viewModel = StateObject(wrappedValue: CreateAlbumViewModel(user: user, profileVM: profileVM))
    }
    var body: some View {
        ZStack {
            ScrollView {
                LazyVStack(spacing: 16){
                    HeaderMain( action: {
                        dismiss()
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
                        
                        CustomTextField(text: $viewModel.title, textInfo: "Write album name...", secureField: false)
                    }.padding(.horizontal, 16)
                    
                    LazyVStack(spacing: 0){
                        Text("Choose Flavors")
                            .font(.primaryFont(.P1))
                            .fontWeight(.semibold)
                        
                        Rectangle()
                            .fill(Color(.systemGray))
                            .frame(height: 1)
                            
                    }
                }
            }
            
            if viewModel.showImagePicker{
                ImagePickerOptions(image: $viewModel.image, uiimage: $viewModel.uiImage, showView: $viewModel.showImagePicker, imageType: .albumImage)
            }
            
        }
    }
}

#Preview {
    CreateAlbumView(user: User.mockUsers[0], profileVM: ProfileViewModel(user: User.mockUsers[0]))
}
