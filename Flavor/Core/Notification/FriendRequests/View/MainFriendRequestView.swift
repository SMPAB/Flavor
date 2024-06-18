//
//  MainFriendRequestView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-17.
//

import SwiftUI

struct MainFriendRequestView: View {
    
    @EnvironmentObject var homeVM: HomeViewModel
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ScrollView{
            HStack{
                Button(action: {
                    dismiss()
                }){
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.black)
                }
                
                Spacer()
                
                Text("Friend Requests")
                    .font(.primaryFont(.H4))
                    .foregroundStyle(.black)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Image(systemName: "chevron.left")
                    .opacity(0)
            }.padding(.horizontal, 16)
            
            
            if !homeVM.friendRequestUsernames.isEmpty{
                LazyVStack{
                    ForEach(homeVM.friendRequestUsernames, id: \.self){ username in
                       FriendRequestCell(homeVM: homeVM, username: username)
                            .environmentObject(homeVM)
                    }
                }
            } else {
                VStack{
                    Text("you have no friend requests")
                        .font(.primaryFont(.P1))
                        .foregroundStyle(Color(.systemGray))
                }.padding(.top, 300)
            }
        }.refreshable {
            Task{
               try await homeVM.fetchFriendRequests()
            }
        }
    }
}

#Preview {
    MainFriendRequestView()
}
