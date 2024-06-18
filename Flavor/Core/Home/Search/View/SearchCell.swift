//
//  SearchCell.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-16.
//

import SwiftUI

struct SearchCell: View {
    @StateObject var viewModel: SearchCellViewModel
    @EnvironmentObject var homeVM: HomeViewModel
    init(username: String){
        self._viewModel = StateObject(wrappedValue: SearchCellViewModel(username: username))
    }
    var body: some View {
        ZStack{
            if let user = viewModel.user {
                NavigationLink(destination:
                                ProfileView(user: user)
                    .environmentObject(homeVM)
                ) {
                    HStack{
                        ImageView(size: .small, imageUrl: user.profileImageUrl, background: false)
                        
                        Text("@\(user.userName)")
                            .font(.primaryFont(.P1))
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.black)
                    }
                }
            } else {
                HStack{
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemGray6))
                        .frame(width: 48, height: 48)
                    
                    VStack(alignment: .leading){
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color(.systemGray6))
                            .frame(width: 120, height: 10)
                        
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color(.systemGray6))
                            .frame(width: 160, height: 10)
                    }
                    
                    
                    Spacer()
                }
            }
        }.onFirstAppear {
            Task{
                try await viewModel.fetchUser()
            }
        }
        .foregroundStyle(.black)
    }
}
/*
#Preview {
    SearchCell()
}*/
