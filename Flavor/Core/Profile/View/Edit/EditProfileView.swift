//
//  EditProfileView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-12.
//

import SwiftUI

struct EditProfileView: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            VStack(spacing: 16){
                HeaderMain(action: {
                    Task{
                        try await viewModel.updateUserData()
                        dismiss()
                    }
                   
                }, cancelText: "Cancel", title: "Edit Profile", actionText: "Save")
                
                ZStack{
                    if let image = viewModel.image{
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 72, height: 72)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .contentShape(RoundedRectangle(cornerRadius: 8))
                            .onTapGesture {
                                viewModel.showImageView.toggle()
                            }
                    } else {
                        ImageView(size: .medium, imageUrl: viewModel.user.profileImageUrl, background: false)
                            .onTapGesture {
                                viewModel.showImageView.toggle()
                            }
                    }
                    
                    ZStack{
                        Circle()
                            .fill(Color(.systemGray6))
                            .stroke(Color(.systemGray))
                            .frame(width: 35, height: 35)
                            
                        
                        Image(systemName: "camera.fill")
                            .resizable()
                            .frame(width: 22, height: 18)
                    }.offset(x: 32, y: 32)
                    
                }
                
                VStack(alignment: .leading){
                    Text("Biography")
                        .font(.primaryFont(.P1))
                        .fontWeight(.semibold)
                    
                    TextField("Write your caption...", text: $viewModel.caption, axis: .vertical)
                        .font(.primaryFont(.P1))
                        .padding(8)
                        .multilineTextAlignment(.leading)
                        .frame(height: 137, alignment: .top)
                        .frame(maxWidth: .infinity)
                        .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.colorWhite)
                            .stroke(Color(.systemGray))
                        )
                        
                }
                
                Toggle(isOn: $viewModel.PublicAccount, label: {
                    Text("Public Account")
                        .font(.primaryFont(.P1))
                        .fontWeight(.semibold)
                        .foregroundStyle(.black)
                }).tint(.colorOrange)
                
                
                Spacer()
                
            }.padding(.horizontal, 16)
            
            if viewModel.showImageView{
                ImagePickerOptions(image: $viewModel.image, uiimage: $viewModel.uiImage, showView: $viewModel.showImageView, imageType: .profileImage)
            }
        }
    }
}

#Preview {
    EditProfileView()
        .environmentObject(ProfileViewModel(user: User.mockUsers[0]))
}
