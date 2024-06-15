//
//  ListCell.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-12.
//

import SwiftUI

struct ListCell: View {
    
    @StateObject var viewModel: ListCellViewModel
    @EnvironmentObject var profileVM: ProfileViewModel
    @EnvironmentObject var homeVM: HomeViewModel
    
    init(username: String) {
        self._viewModel = StateObject(wrappedValue: ListCellViewModel(username: username))
    }
    var body: some View {
        ZStack{
            if let user = viewModel.user {
                NavigationLink(destination: Text(user.userName)){
                    HStack{
                        ImageView(size: .small, imageUrl: user.profileImageUrl, background: true)
                        
                        Text("@\(user.userName)")
                            .font(.primaryFont(.P1))
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Button(action: {
                            handleFollowTapped()
                        }){
                            if user.isFollowed == true {
                                Text("Following")
                                    .font(.primaryFont(.P2))
                                    .foregroundStyle(.black)
                                    .frame(width: 100, height: 32)
                                    .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color(.systemGray6))
                                    )
                            } else if user.hasFriendRequests == true {
                                Text("Request Sent")
                                    .font(.primaryFont(.P2))
                                    .foregroundStyle(.black)
                                    .frame(width: 100, height: 32)
                                    .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color(.systemGray6))
                                    )
                            } else {
                                Text("Follow")
                                    .font(.primaryFont(.P2))
                                    .foregroundStyle(.colorWhite)
                                    .frame(width: 100, height: 32)
                                    .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(.colorOrange)
                                    )
                            }
                        }
                    }
                }
            } else {
                HStack{
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemGray6))
                        .frame(width: 48, height: 48)
                    
                    VStack(alignment: .leading){
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(.systemGray6))
                            .frame(width: 130, height: 10)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(.systemGray6))
                            .frame(width: 170, height: 10)
                    }
                    
                    Spacer()
                }
            }
        }.onFirstAppear {
            Task{
               try await viewModel.fetchUser()
            }
        }
        
    }
    
    private func handleFollowTapped() {
        
       if let user = viewModel.user {
           
           if user.isFollowed == true {
               Task {
                   try await viewModel.unfollow(userToUnfollow: user, userUnfollowing: homeVM.user)
               }
           } else if user.isFollowed == false && user.hasFriendRequests != true{
               if user.publicAccount {
                   //Follow
                   Task{
                       try await viewModel.follow(userToFollow: user, userFollowing: homeVM.user)
                   }
               } else {
                   Task{
                       try await viewModel.sendFriendRequest(sendRequestTo: user, userSending: homeVM.user)
                   }
               }
           } else if user.hasFriendRequests == true {
               //Remove friend request
               Task{
                   try await viewModel.unsendFriendRequest(userToUnFriendRequest: user, userUnfriendrequesting: homeVM.user)
               }
               
           }
           
           
           
        }
    }
}

#Preview {
    ListCell(username: "Hello there")
}
