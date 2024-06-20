//
//  CreatCrewUserCell.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-20.
//

import SwiftUI
import Iconoir

struct CreatCrewUserCell: View {
    
    @StateObject var viewModel: CreateCrewUserCell
    @EnvironmentObject var mainVM: CreateCrewVM
    
    init(userName: String) {
        self._viewModel = StateObject(wrappedValue: CreateCrewUserCell(userName: userName))
    }
    var body: some View {
        ZStack{
            if let user = viewModel.user {
                Button(action: {
                    if mainVM.selectedUsers.contains(where: {$0.id == user.id}){
                        mainVM.selectedUsers.removeAll(where: {$0.id == user.id})
                    } else {
                        mainVM.selectedUsers.append(user)
                    }
                }){
                    HStack{
                        ImageView(size: .small, imageUrl: user.profileImageUrl, background: true)
                        
                        Text("@\(user.userName)")
                            .font(.primaryFont(.P1))
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        if mainVM.selectedUsers.contains(where: {$0.id == user.id}){
                            
                                Iconoir.checkCircleSolid.asImage
                                    .foregroundStyle(.colorOrange)
                            
                        } else {
                            
                                Iconoir.checkCircle.asImage
                                    .foregroundStyle(.black)
                            
                        }
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
        }.onFirstAppear {
            Task{
                try await viewModel.fetchUser()
            }
        }
    }
}
