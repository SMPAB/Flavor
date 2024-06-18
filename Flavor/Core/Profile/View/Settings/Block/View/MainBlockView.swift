//
//  MainBlockView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-17.
//

import SwiftUI

struct MainBlockView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var profileVM: ProfileViewModel
    @StateObject var viewModel = MainBlockedViewModel()
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
                
                Text("Blocked Users")
                    .font(.primaryFont(.H4))
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
                
                Spacer()
                
                Image(systemName: "chevron.left")
                    .opacity(0)
            }.padding(.horizontal, 16)
            
            if !viewModel.blockedUsernames.isEmpty{
                LazyVStack{
                    ForEach(viewModel.blockedUsernames, id: \.self){ username in
                        BlockCell(username: username)
                            .environmentObject(viewModel)
                            .environmentObject(profileVM)
                    }
                }
            } else {
                Text("You have no blocked users")
                    .font(.primaryFont(.P1))
                    .foregroundStyle(Color(.systemGray))
                    .padding(.top, 350)
            }
            
            
        }.onFirstAppear {
            Task{
                try await viewModel.fetchUsernames()
            }
        }
    }
}

#Preview {
    MainBlockView()
}
