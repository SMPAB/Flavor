//
//  VoteCell.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-28.
//

import SwiftUI
import Kingfisher

struct VoteCell: View {
    
    let challengePost: ChallengeUpload
    @EnvironmentObject var challengeVM: ChallengeViewModel
    
    var body: some View {
        
        
        let width = UIScreen.main.bounds.width
        VStack{
            HStack{
                Text("Viewing:")
                    .font(.primaryFont(.H4))
                    .foregroundStyle(.colorWhite)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("@\(challengePost.user?.userName ?? "")")
                    .font(.primaryFont(.H4))
                    .foregroundStyle(.colorWhite)
                    .fontWeight(.semibold)
            }
            
            if let imageUrl = challengePost.imageUrl {
                KFImage(URL(string: imageUrl))
                    .resizable()
                    .scaledToFill()
                    .frame(width: width - 48, height: width - 48)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .contentShape(RoundedRectangle(cornerRadius: 16))
            } else {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemGray6))
                    .frame(width: width - 48, height: width - 48)
            }
            
            
            
            VStack(alignment: .leading){
                Text("\(challengePost.votes)")
                    .font(.primaryFont(.H4))
                    .foregroundStyle(.colorWhite)
                    .fontWeight(.semibold)
                
                Text(challengePost.title)
                    .font(.primaryFont(.H4))
                    .foregroundStyle(.colorWhite)
                    .fontWeight(.semibold)
                
                
                HStack(spacing: 8){
                    Button(action: {
                        withAnimation(.spring(duration: 0.2, bounce: 0.4)){
                            challengeVM.votePost = challengePost
                            challengeVM.showVote = true
                        }
                        
                    }){
                        Text("Vote")
                            .font(.primaryFont(.H4))
                            .foregroundStyle(.black)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .frame(height: 58)
                            .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.colorWhite)
                                .stroke(.colorWhite)
                            )
                    }
                    
                    Spacer()
                    Button(action: {
                        
                    }){
                        Text("Next")
                            .font(.primaryFont(.H4))
                            .foregroundStyle(.colorWhite)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .frame(height: 58)
                            .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.colorOrange)
                                .stroke(.colorWhite)
                            )
                    }
                }
            }
        }.padding(16)
        .background(
        
            RoundedRectangle(cornerRadius: 16)
                .fill(.colorOrange)
        )
    }
}
/*
#Preview {
    VoteCell()
}*/
