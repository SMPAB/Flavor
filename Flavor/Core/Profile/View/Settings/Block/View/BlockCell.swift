//
//  BlockCell.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-17.
//

import SwiftUI

struct BlockCell: View {
    
    @StateObject var viewModel: BlockCellViewModel
    @EnvironmentObject var profileVM: ProfileViewModel
    @EnvironmentObject var mainBlockVM: MainBlockedViewModel
    
    init( username: String){
        self._viewModel = StateObject(wrappedValue: BlockCellViewModel(username: username))
    }
    
    var body: some View {
        ZStack{
            if let user = viewModel.user {
                    HStack{
                        ImageView(size: .small, imageUrl: user.profileImageUrl, background: false)
                        
                        Text("@\(user.userName)")
                            .font(.primaryFont(.P1))
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Button(action: {
                            Task{
                                mainBlockVM.blockedUsernames.removeAll(where: {$0 == user.userName})
                                try await viewModel.unblock(currentUser: profileVM.user)
                            }
                        }){
                            Text("Unblock")
                                .font(.primaryFont(.P1))
                                .fontWeight(.semibold)
                                .foregroundStyle(.colorWhite)
                                .frame(width: 100, height: 32 )
                        }.background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(.colorOrange)
                                .stroke(Color(.colorOrange))
                        )
                        
                       
                    }.foregroundStyle(.black)
                
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
    BlockCell(username: "")
}
