//
//  RecomendedCell.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-07-14.
//

import SwiftUI

struct RecomendedCell: View {
    
    @StateObject var viewModel: RecomendedCellViewModel
    @EnvironmentObject var homeVM: HomeViewModel
    
    init(user: User) {
        self._viewModel = StateObject(wrappedValue: RecomendedCellViewModel(user: user))
    }
    
    var user: User {
        return viewModel.user
    }
    
    var isFollowed: Bool {
        return user.isFollowed ?? false
    }
    var body: some View {
        HStack{
            ImageView(size: .small, imageUrl: user.profileImageUrl, background: true)
            
            Text("@\(user.userName)")
                .font(.primaryFont(.P1))
                .fontWeight(.semibold)
            
            Spacer()
            
            Button(action: {handleFollowTapped()}){
                if isFollowed {
                    Text("Unfollow")
                        .font(.primaryFont(.P2))
                        .fontWeight(.semibold)
                        .foregroundStyle(.black)
                        .frame(width: 100, height: 32)
                        .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(.systemGray6))
                        )
                } else {
                    Text("Follow")
                        .font(.primaryFont(.P2))
                        .fontWeight(.semibold)
                        .foregroundStyle(.colorWhite)
                        .frame(width: 100, height: 32)
                        .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(.colorOrange))
                        )
                }
            }
        }.onChange(of: homeVM.recomendedUsers.first(where: {$0.id == user.id})){
            if let user = homeVM.recomendedUsers.first(where: {$0.id == user.id}) {
                viewModel.user = user
            }
            
        }
    }
    
    func handleFollowTapped() {
        if isFollowed {
            Task {
                try await viewModel.unfollow(currentUser: homeVM.user)
            }
        } else {
            Task {
                try await viewModel.follow(currentUser: homeVM.user)
            }
        }
    }
}

#Preview {
    RecomendedCell(user: User.mockUsers[0])
}
