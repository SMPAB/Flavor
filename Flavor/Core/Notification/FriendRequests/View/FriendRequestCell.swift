//
//  FriendRequestCell.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-17.
//

import SwiftUI

struct FriendRequestCell: View {
    
    @StateObject var viewModel: FriendRequestCellViewModel
    @EnvironmentObject var homeVM: HomeViewModel
    
    init(homeVM: HomeViewModel, username: String){
        self._viewModel = StateObject(wrappedValue: FriendRequestCellViewModel(userName: username, homeVM: homeVM))
    }
    
    var body: some View {
        ZStack{
            if let user = viewModel.user {
                NavigationLink(destination: ProfileView(user: user)
                    .environmentObject(homeVM)) {
                    HStack{
                        ImageView(size: .small, imageUrl: user.profileImageUrl, background: false)
                        
                        Text("@\(user.userName)")
                            .font(.primaryFont(.P1))
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Button(action: {
                            Task{
                                try await viewModel.accept()
                            }
                        }){
                            Text("Accept")
                                .font(.primaryFont(.P1))
                                .fontWeight(.semibold)
                                .foregroundStyle(.colorWhite)
                                .frame(width: 80, height: 32 )
                        }.background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(.colorOrange)
                                .stroke(Color(.colorOrange))
                        )
                        
                        Button(action: {
                            Task{
                                try await viewModel.remove()
                            }
                        }){
                            Text("Remove")
                                .font(.primaryFont(.P1))
                                .fontWeight(.semibold)
                                .foregroundStyle(.black)
                                .frame(width: 80, height: 32 )
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(.colorWhite)
                                .stroke(Color(.systemGray))
                        )
                    }.foregroundStyle(.black)
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
        }.padding(.horizontal, 16)
        .onFirstAppear {
            Task{
                try await viewModel.fetchUser()
            }
        }
    }
}

#Preview {
    FriendRequestCell(homeVM: HomeViewModel(user: User.mockUsers[0]), username: "")
}
