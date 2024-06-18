//
//  BlockView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-17.
//

import SwiftUI

struct BlockView: View {
    
    @EnvironmentObject var viewModel: ProfileViewModel
    @EnvironmentObject var homeVM: HomeViewModel
    var body: some View {
        VStack(spacing: 16){
            ImageView(size: .large, imageUrl: viewModel.user.profileImageUrl, background: false)
            
            Text("Do you want to block \(viewModel.user.userName)")
                .font(.primaryFont(.H4))
                .fontWeight(.semibold)
            
            Text("\(viewModel.user.userName) wont be able to find your profile, and you wont be able to find their profile. You can modify your blocked user in settings")
                .font(.primaryFont(.P1))
                .foregroundStyle(Color(.systemGray))
                .multilineTextAlignment(.center)
            
            Divider()
            
            CustomButton(text: "Block", textColor: .colorWhite, backgroundColor: .colorOrange, strokeColor: .colorOrange, action: {
                Task{
                    try await viewModel.block(currentUser: homeVM.user)
                    try await viewModel.unfollow(userToUnfollow: viewModel.user, userUnfollowing: homeVM.user)
                    try await viewModel.unsendFriendRequest(userToUnFriendRequest: viewModel.user, userUnfriendrequesting: homeVM.user)
                    try await viewModel.unfollow(userToUnfollow: homeVM.user, userUnfollowing: viewModel.user)
                    try await viewModel.unsendFriendRequest(userToUnFriendRequest: homeVM.user, userUnfriendrequesting: viewModel.user)
                    viewModel.showBlock.toggle()
                }
            })
            
            Button(action: {
                viewModel.showBlock.toggle()
            }){
                Text("Cancel")
                    .font(.primaryFont(.P1))
            }
        }.padding(.horizontal, 16)
    }
}

#Preview {
    BlockView()
        .environmentObject(ProfileViewModel(user: User.mockUsers[0]))
}
